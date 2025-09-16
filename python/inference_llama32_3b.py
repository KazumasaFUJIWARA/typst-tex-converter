#!/usr/bin/env python3
"""
学習済みLlama 3.2 3B QLoRAモデルを使用したLaTeX→Typst変換スクリプト
"""

import argparse
import torch
import os
import time
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
        
        # アシスタントの応答部分を抽出（新しい解析方法）
        print(f"  生成テキスト全体の長さ: {len(generated_text)} 文字")
        print(f"  プロンプトの長さ: {len(prompt)} 文字")
        
        # 方法1: プロンプト部分を除去
        if generated_text.startswith(prompt):
            response = generated_text[len(prompt):].strip()
            print(f"  方法1（プロンプト除去）: {len(response)} 文字")
        else:
            response = generated_text.strip()
            print(f"  方法1（全体使用）: {len(response)} 文字")
        
        # 方法2: アシスタントマーカーで抽出
        assistant_marker = "<|start_header_id|>assistant<|end_header_id|>"
        if assistant_marker in generated_text:
            assistant_response = generated_text.split(assistant_marker)[-1].strip()
            print(f"  方法2（アシスタントマーカー）: {len(assistant_response)} 文字")
            
            # 次のマーカーで切る
            if "<|start_header_id|>" in assistant_response:
                assistant_response = assistant_response.split("<|start_header_id|>")[0].strip()
                print(f"  方法2（マーカーで切る後）: {len(assistant_response)} 文字")
            
            # より長い応答を選択
            if len(assistant_response) > len(response):
                response = assistant_response
                print(f"  方法2を採用: {len(response)} 文字")
        
        # 方法3: ```typstマーカーで抽出
        if "```typst" in response:
            typst_start = response.find("```typst")
            typst_content = response[typst_start:].strip()
            print(f"  方法3（```typstマーカー）: {len(typst_content)} 文字")
            
            # 最後の```を除去
            if typst_content.endswith('```'):
                typst_content = typst_content[:-3].strip()
                print(f"  方法3（```除去後）: {len(typst_content)} 文字")
            
            # より長い応答を選択
            if len(typst_content) > len(response):
                response = typst_content
                print(f"  方法3を採用: {len(response)} 文字")
        
        # デバッグ: 最終的な応答の内容を表示
        print(f"  最終応答: {response[:200]}...")
        print(f"  最終応答の最後: ...{response[-100:]}")
        
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
    """LaTeXテキストを前処理（適切な分割）"""
    # 全文を1つのチャンクとして処理（分割を簡素化）
    # 長すぎる場合は文書構造で分割
    if len(latex_text) > 3000:
        # 文書構造で分割
        chunks = []
        
        # \section, \subsection, \begin{document}等で分割
        sections = re.split(r'(\\section\{[^}]*\}|\\subsection\{[^}]*\}|\\begin\{document\})', latex_text)
        
        current_chunk = ""
        for section in sections:
            if len(current_chunk + section) > 3000:
                if current_chunk.strip():
                    chunks.append(current_chunk.strip())
                current_chunk = section
            else:
                current_chunk += section
        
        if current_chunk.strip():
            chunks.append(current_chunk.strip())
        
        # チャンクが空の場合は元のテキストをそのまま使用
        if not chunks:
            chunks = [latex_text]
    else:
        # 短い場合は全文を1つのチャンクとして処理
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
    
    # 出力ファイルに保存（新しい形式）
    print(f"結果を {args.output_file} に保存中...")
    with open(args.output_file, 'w', encoding='utf-8') as f:
        f.write("# プロンプト\n")
        f.write("``` plain text\n")
        f.write("LaTeX 形式の文章を Typst形式 へ変換してください.\n")
        f.write("重要: TypstはLaTeXの代替となる文書組版システムです。TypeScript（プログラミング言語）ではありません。\n")
        f.write("出力はTypst構文のみ。プログラミングコードは出力しません。\n")
        f.write("```\n\n")
        
        f.write("# 元の文\n")
        f.write("``` LaTeX\n")
        f.write(latex_content)
        f.write("\n```\n\n")
        
        f.write("# 出力\n")
        f.write("``` Typst\n")
        f.write(typst_content)
        f.write("\n```\n\n")
        
        # ログファイルへの参照と要約を追加
        f.write("---\n")
        f.write("## 学習情報\n")
        f.write(f"- **学習ログ**: `../logs/{os.path.basename(args.output_file).replace('.md', '_training_*.log')}`\n")
        f.write(f"- **テストログ**: `../logs/{os.path.basename(args.output_file).replace('.md', '_test_*.log')}`\n")
        f.write(f"- **生成時刻**: {time.strftime('%Y-%m-%d %H:%M:%S')}\n")
        f.write(f"- **入力文字数**: {len(latex_content)}\n")
        f.write(f"- **出力文字数**: {len(typst_content)}\n")
        f.write(f"- **チャンク数**: {len(latex_chunks)}\n")
    
    print("変換完了！")

if __name__ == "__main__":
    main()
