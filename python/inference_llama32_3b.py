#!/usr/bin/env python3
"""
学習済みLlama 3.2 3B QLoRAモデルを使用したLaTeX→Typst変換スクリプト
"""

import argparse
import torch
import os
from transformers import AutoTokenizer, AutoModelForCausalLM, BitsAndBytesConfig
from peft import PeftModel
import json
import re

# 警告を抑制（生成時の無効パラメータ警告のみ）
os.environ["TRANSFORMERS_VERBOSITY"] = "warning"

def load_model_and_tokenizer(model_id, peft_model_path=None, use_baseline=False):
    """学習済みモデルとトークナイザーを読み込み"""
    print(f"トークナイザーを読み込み中...")
    tokenizer = AutoTokenizer.from_pretrained(model_id)
    tokenizer.pad_token = tokenizer.eos_token
    tokenizer.padding_side = "left"
    
    print(f"4bit量子化設定を準備中...")
    bnb_config = BitsAndBytesConfig(
        load_in_4bit=True,
        bnb_4bit_use_double_quant=True,
        bnb_4bit_quant_type="nf4",
        bnb_4bit_compute_dtype=torch.bfloat16
    )
    
    print(f"ベースモデルを読み込み中...")
    model = AutoModelForCausalLM.from_pretrained(
        model_id,
        quantization_config=bnb_config,
        device_map="auto",
        trust_remote_code=True
    )
    
    if use_baseline:
        print(f"✅ ベースラインモデルを使用します（LoRAなし）")
        print(f"   モデルID: {model_id}")
        print(f"   PEFTモデルは読み込みません")
    else:
        print(f"✅ PEFTモデルを読み込み中...")
        print(f"   PEFTパス: {peft_model_path}")
        model = PeftModel.from_pretrained(model, peft_model_path)
        print(f"   PEFTモデル読み込み完了")
    
    return model, tokenizer

def format_prompt(latex_text, tokenizer, use_baseline=False):
    """LaTeXテキストをプロンプト形式にフォーマット"""
    if use_baseline:
        # ベースラインモデル用の簡潔で明確なプロンプト
        system_prompt = """LaTeXをTypstに変換してください。

重要: Typstは文書組版システムです。プログラミングコードは出力しません。

まず全文コピー

変換ルール:
- \\begin{align} → $
- \\end{align} → $
- \\begin{cases} → cases(
- \\end{cases} → )
- \\partial_t → partial_t
- \\Delta → Delta
- \\mathbb{R} → RR
- \\in → in
- \\left( → (
- \\right) → )
- \\begin{document} → (削除)
- \\end{document} → (削除)
- \\maketitle → (削除)
- \\section{title} → = title

出力はTypst構文のみ。説明や注釈は不要。"""
    else:
        # 学習済みモデル用のプロンプト（Typstの説明を明確化）
        system_prompt = """LaTeX 形式の文章を Typst形式 へ変換してください.
重要: TypstはLaTeXの代替となる文書組版システムです。TypeScript（プログラミング言語）ではありません。
出力はTypst構文のみ。プログラミングコードは出力しません。"""
    
    messages = [
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": latex_text}
    ]
    
    try:
        formatted_prompt = tokenizer.apply_chat_template(
            messages,
            tokenize=False,
            add_generation_prompt=True
        )
        print(f"  チャットテンプレート適用成功")
        return formatted_prompt
    except Exception as e:
        print(f"  チャットテンプレート適用エラー: {e}")
        # フォールバック: Llama 3.2の正しい形式
        return f"<|begin_of_text|><|start_header_id|>system<|end_header_id|>\n\n{system_prompt}<|eot_id|><|start_header_id|>user<|end_header_id|>\n\n{latex_text}<|eot_id|><|start_header_id|>assistant<|end_header_id|>\n\n"

def convert_latex_to_typst(model, tokenizer, latex_text, max_length=1024, use_baseline=False):
    """LaTeXテキストをTypstに変換"""
    try:
        print(f"  入力テキスト長: {len(latex_text)} 文字")
        
        # プロンプトをフォーマット
        prompt = format_prompt(latex_text, tokenizer, use_baseline)
        print(f"  プロンプト長: {len(prompt)} 文字")
        
        # トークン化
        inputs = tokenizer(prompt, return_tensors="pt", truncation=True, max_length=max_length)
        inputs = {k: v.to(model.device) for k, v in inputs.items()}
        print(f"  入力トークン数: {inputs['input_ids'].shape[1]}")
        
        # 生成（グリーディサンプリング用の最適化設定）
        print("  生成開始...")
        with torch.no_grad():
            outputs = model.generate(
                **inputs,
                max_new_tokens=512,  # トークン数を増加
                do_sample=False,  # グリーディサンプリング
                pad_token_id=tokenizer.eos_token_id,
                eos_token_id=tokenizer.eos_token_id,
                repetition_penalty=1.1,
                use_cache=True,
                # temperature, top_p, top_kはdo_sample=Falseの場合は無効なので明示的に除外
            )
        
        print(f"  生成完了: {outputs.shape[1]} トークン")
        
        # デコード
        generated_text = tokenizer.decode(outputs[0], skip_special_tokens=True)
        print(f"  生成テキスト長: {len(generated_text)} 文字")
        print(f"  プロンプト長: {len(prompt)} 文字")
        
        # デバッグ: 生成されたテキストの最初と最後の部分を表示
        print(f"  生成テキスト開始: {generated_text[:200]}...")
        print(f"  生成テキスト終了: ...{generated_text[-200:]}")
        
        # アシスタントの応答部分を抽出（簡素化）
        assistant_marker = "<|start_header_id|>assistant<|end_header_id|>"
        
        if assistant_marker in generated_text:
            # アシスタントマーカー以降の部分を抽出
            response = generated_text.split(assistant_marker)[-1].strip()
            print(f"  アシスタント応答抽出: {len(response)} 文字")
        else:
            # シンプルなフォールバック: プロンプト部分を除去
            if generated_text.startswith(prompt):
                response = generated_text[len(prompt):].strip()
                print(f"  プロンプト除去による応答抽出: {len(response)} 文字")
            else:
                # 最後の手段: 全体を使用
                response = generated_text.strip()
                print(f"  全体を応答として使用: {len(response)} 文字")
        
        # TypeScriptコードが生成された場合の警告
        if response and ("import" in response or "void main()" in response or "writeln" in response or "typscript" in response.lower()):
            print("  警告: TypeScriptコードが生成されました。Typstコードを期待しています。")
            print("  原因: モデルがTypstをTypeScriptと混同している可能性があります。")
        
        # デバッグ: 抽出された応答の内容を表示
        print(f"  抽出された応答: {response[:100]}...")
        
        if not response:
            print("  警告: 応答が空です")
            return "変換結果なし"
        
        return response
        
    except Exception as e:
        print(f"変換エラーの詳細: {e}")
        import traceback
        traceback.print_exc()
        return f"# 変換エラー: {e}"

def preprocess_latex(latex_text):
    """LaTeXテキストを前処理（数式環境を考慮した分割）"""
    # 数式環境の境界を保持しながら分割
    chunks = []
    
    # 数式環境（align, equation, cases等）を検出
    math_environments = [
        r'\\begin\{align\}.*?\\end\{align\}',
        r'\\begin\{equation\}.*?\\end\{equation\}',
        r'\\begin\{cases\}.*?\\end\{cases\}',
        r'\\begin\{array\}.*?\\end\{array\}',
        r'\\begin\{matrix\}.*?\\end\{matrix\}',
        r'\\begin\{pmatrix\}.*?\\end\{pmatrix\}',
        r'\\begin\{bmatrix\}.*?\\end\{bmatrix\}',
        r'\\begin\{vmatrix\}.*?\\end\{vmatrix\}',
    ]
    
    # 数式環境を一時的にマーク
    marked_text = latex_text
    math_placeholders = []
    
    for i, pattern in enumerate(math_environments):
        matches = re.finditer(pattern, marked_text, re.DOTALL)
        for match in reversed(list(matches)):  # 後ろから置換してインデックスを保持
            placeholder = f"__MATH_ENV_{i}_{len(math_placeholders)}__"
            math_placeholders.append(match.group())
            marked_text = marked_text[:match.start()] + placeholder + marked_text[match.end():]
    
    # 段落単位で分割
    paragraphs = marked_text.split('\n\n')
    
    for para in paragraphs:
        para = para.strip()
        if para and len(para) > 5:  # 空でない段落のみ
            # 数式環境のプレースホルダーを元に戻す
            for i, placeholder in enumerate([f"__MATH_ENV_{j}_{i}__" for j in range(len(math_environments)) for i in range(len(math_placeholders))]):
                if placeholder in para:
                    para = para.replace(placeholder, math_placeholders[i])
            
            # 長すぎる段落は文単位で分割（数式環境は保持）
            if len(para) > 1500:  # 制限を緩和
                # 数式環境内でない文の境界で分割
                sentences = re.split(r'(?<=[.!?])\s+(?![^\\]*\\end\{)', para)
                current_chunk = ""
                for sentence in sentences:
                    if len(current_chunk + sentence) > 1500:
                        if current_chunk:
                            chunks.append(current_chunk.strip())
                        current_chunk = sentence
                    else:
                        current_chunk += " " + sentence if current_chunk else sentence
                if current_chunk:
                    chunks.append(current_chunk.strip())
            else:
                chunks.append(para)
    
    # チャンクが空の場合は元のテキストをそのまま使用
    if not chunks:
        chunks = [latex_text]
    
    return chunks

def main():
    parser = argparse.ArgumentParser(description="学習済みLlama 3.2 3B QLoRAモデルでLaTeX→Typst変換")
    parser.add_argument("--model_id", default="meta-llama/Llama-3.2-3B-Instruct", 
                       help="ベースモデルのID")
    parser.add_argument("--peft_model_path", default="outputs/llama32-3b-typst-qlora-v2", 
                       help="学習済みPEFTモデルのパス")
    parser.add_argument("--input_file", required=True, 
                       help="入力LaTeXファイル")
    parser.add_argument("--output_file", required=True, 
                       help="出力Typstファイル")
    parser.add_argument("--max_length", type=int, default=2048, 
                       help="最大入力長")
    parser.add_argument("--baseline", action="store_true", 
                       help="ベースライン（LoRAなし）モデルを使用")
    parser.add_argument("--no-chunking", action="store_true",
                       help="チャンク分割を無効化（全文を一度に変換）")
    
    args = parser.parse_args()
    
    print(f"ベースモデル: {args.model_id}")
    if args.baseline:
        print(f"✅ 使用モデル: ベースライン（LoRAなし）")
        print(f"   PEFTモデルは使用しません")
    else:
        print(f"✅ 使用モデル: PEFT（LoRA適用済み）")
        print(f"   PEFTモデル: {args.peft_model_path}")
    print(f"入力ファイル: {args.input_file}")
    print(f"出力ファイル: {args.output_file}")
    
    # モデルとトークナイザーを読み込み
    model, tokenizer = load_model_and_tokenizer(args.model_id, args.peft_model_path, args.baseline)
    
    # 入力ファイルを読み込み
    print(f"LaTeXファイルを読み込み中...")
    with open(args.input_file, 'r', encoding='utf-8') as f:
        latex_content = f.read()
    
    # LaTeXテキストを前処理
    if args.no_chunking:
        print("チャンク分割を無効化: 全文を一度に変換します")
        latex_chunks = [latex_content]
    else:
        latex_chunks = preprocess_latex(latex_content)
        print(f"LaTeXテキストを {len(latex_chunks)} チャンクに分割しました")
    
    print(f"LaTeX→Typst変換を開始します...")
    typst_parts = []
    
    for i, chunk in enumerate(latex_chunks):
        if args.no_chunking:
            print("全文を変換中...")
        else:
            print(f"チャンク {i+1}/{len(latex_chunks)} を変換中...")
        typst_part = convert_latex_to_typst(model, tokenizer, chunk, args.max_length, args.baseline)
        typst_parts.append(typst_part)
    
    # 結果を結合
    if args.no_chunking:
        typst_content = typst_parts[0]  # チャンク分割なしの場合は1つの結果のみ
    else:
        typst_content = "\n\n".join(typst_parts)
    
    # 出力ファイルに保存
    print(f"結果を {args.output_file} に保存中...")
    with open(args.output_file, 'w', encoding='utf-8') as f:
        f.write(typst_content)
    
    print("変換完了！")

if __name__ == "__main__":
    main()
