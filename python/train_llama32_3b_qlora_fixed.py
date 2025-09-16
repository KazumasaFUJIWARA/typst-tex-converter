#!/usr/bin/env python3
"""
Llama 3.2 3B Instruct専用 QLoRA学習スクリプト（修正版）
最新のtransformersライブラリに対応
"""

import argparse
import torch
import os
from datasets import load_dataset
from transformers import AutoTokenizer, AutoModelForCausalLM, TrainingArguments, BitsAndBytesConfig
from trl import SFTTrainer
from peft import LoraConfig

def main():
    parser = argparse.ArgumentParser(description="Llama 3.2 3B専用 QLoRA学習スクリプト（修正版）")
    parser.add_argument("--model_id", default="meta-llama/Llama-3.2-3B-Instruct", 
                       help="Llama 3.2 3BモデルのIDまたはパス")
    parser.add_argument("--data", default="jsonl/train.jsonl", 
                       help="学習データファイル")
    parser.add_argument("--text_field", default=None, 
                       help="テキストフィールド名（会話形式の場合は不要）")
    parser.add_argument("--out", default="outputs/llama32-3b-typst-qlora", 
                       help="出力ディレクトリ")
    parser.add_argument("--max_len", type=int, default=1024, 
                       help="最大シーケンス長（3B推奨: 1024）")
    parser.add_argument("--batch_size", type=int, default=1, 
                       help="デバイスあたりのバッチサイズ（メモリ不足対策で1に削減）")
    parser.add_argument("--grad_accum", type=int, default=16, 
                       help="勾配累積ステップ数（メモリ不足対策で16に増加）")
    parser.add_argument("--learning_rate", type=float, default=1e-5, 
                       help="学習率（逐次学習用: 1e-5）")
    parser.add_argument("--epochs", type=int, default=5, 
                       help="エポック数（3Bは軽量なので増加可能）")
    parser.add_argument("--lora_r", type=int, default=16, 
                       help="LoRA rank（逐次学習用: 16）")
    parser.add_argument("--lora_alpha", type=int, default=32, 
                       help="LoRA alpha（逐次学習用: 32）")
    parser.add_argument("--lora_dropout", type=float, default=0.1, 
                       help="LoRA dropout")
    parser.add_argument("--resume_from_checkpoint", type=str, default=None,
                       help="チェックポイントから学習を再開するパス")
    parser.add_argument("--peft_model_path", type=str, default=None,
                       help="既存のPEFTモデルから継続学習するパス")
    parser.add_argument("--continue_training", action="store_true",
                       help="既存のPEFTモデルから継続学習")
    
    args = parser.parse_args()
    
    # 出力ディレクトリを作成
    os.makedirs(args.out, exist_ok=True)
    
    print(f"Llama 3.2 3Bモデル: {args.model_id}")
    print(f"データ: {args.data}")
    print(f"出力: {args.out}")
    print(f"学習率: {args.learning_rate}")
    print(f"エポック数: {args.epochs}")
    print(f"バッチサイズ: {args.batch_size}")
    print(f"勾配累積: {args.grad_accum}")
    print(f"LoRA rank: {args.lora_r}")
    print(f"LoRA alpha: {args.lora_alpha}")
    print(f"LoRA dropout: {args.lora_dropout}")
    print("=" * 50)  # 区切り線を追加
    
    # 継続学習の確認
    if args.continue_training:
        if not os.path.exists(args.out):
            print(f"エラー: 継続学習先のディレクトリ '{args.out}' が見つかりません")
            exit(1)
        print(f"継続学習モード: 既存のPEFTモデル '{args.out}' から継続学習します")
    
    # トークナイザーの読み込み
    print("トークナイザーを読み込み中...")
    tokenizer = AutoTokenizer.from_pretrained(args.model_id, use_fast=False)
    
    # Llama 3.2用のパディングトークン設定
    if tokenizer.pad_token is None:
        tokenizer.pad_token = tokenizer.eos_token
        tokenizer.pad_token_id = tokenizer.eos_token_id
    
    # 4bit量子化設定（最新の方法）
    print("4bit量子化設定を準備中...")
    bnb_config = BitsAndBytesConfig(
        load_in_4bit=True,
        bnb_4bit_use_double_quant=True,
        bnb_4bit_quant_type="nf4",
        bnb_4bit_compute_dtype=torch.float16  # bfloat16からfloat16に変更（警告1の対策）
    )
    
    # モデルの読み込み（最新の方法）
    print("モデルを読み込み中...")
    model = AutoModelForCausalLM.from_pretrained(
        args.model_id,
        quantization_config=bnb_config,
        device_map="auto",
        dtype=torch.float16,  # bfloat16からfloat16に変更（警告1の対策）
        trust_remote_code=True
    )
    
    # 継続学習の場合、既存のPEFTモデルを読み込み
    if args.continue_training or args.peft_model_path:
        peft_path = args.peft_model_path if args.peft_model_path else args.out
        print(f"既存のPEFTモデルを読み込み中: {peft_path}")
        from peft import PeftModel
        # 既存のPEFT設定をクリアしてから読み込み（警告2の対策）
        if hasattr(model, 'peft_config'):
            print("既存のPEFT設定をクリア中...")
            model = model.base_model
        model = PeftModel.from_pretrained(model, peft_path)
    
    # Llama 3.2 3B専用LoRA設定
    lora_config = LoraConfig(
        r=args.lora_r,
        lora_alpha=args.lora_alpha,
        lora_dropout=args.lora_dropout,
        target_modules=[
            "q_proj", "v_proj", "k_proj", "o_proj", 
            "gate_proj", "up_proj", "down_proj"
        ],  # Llama 3.2全層対応
        task_type="CAUSAL_LM",
        bias="none",
        use_rslora=True,  # Llama 3.2推奨
        use_dora=False    # 安定性重視
    )
    
    # データセットの読み込み
    print("データセットを読み込み中...")
    dataset = load_dataset("json", data_files=args.data, split="train")
    print(f"データセットサイズ: {len(dataset)}")
    
    # 学習引数の設定（チェックポイント保存を有効化）
    training_args = TrainingArguments(
        output_dir=args.out,
        per_device_train_batch_size=args.batch_size,
        gradient_accumulation_steps=args.grad_accum,
        dataloader_drop_last=False,  # 最後のバッチも使用
        learning_rate=args.learning_rate,
        num_train_epochs=args.epochs,
        max_steps=-1,
        save_steps=1,  # 1ステップごとにチェックポイント保存（継続学習用）
        save_strategy="steps",
        logging_steps=1,  # 1ステップごとにログ出力
        logging_dir=f"{args.out}/logs",
        warmup_ratio=0.1,  # ウォームアップ比率10%（逐次学習用）
        lr_scheduler_type="cosine",  # コサイン学習率スケジューラー（逐次学習用）
        max_grad_norm=1.0,  # 勾配クリッピング（逐次学習用）
        fp16=True,  # float16を使用（警告1の対策）
        bf16=False,
        remove_unused_columns=False,
        dataloader_pin_memory=False,
        dataloader_num_workers=0,  # メモリ不足対策でワーカー数を0に
        report_to=None,
        save_total_limit=1,  # 最新1つのチェックポイントのみ保持（メモリ不足対策）
        load_best_model_at_end=False,
        metric_for_best_model=None,
        greater_is_better=None,
    )
    
    # SFTTrainerの設定（TrainingArgumentsを追加）
    trainer = SFTTrainer(
        model=model,
        train_dataset=dataset,
        peft_config=lora_config,
        args=training_args,
    )
    
    # 学習開始
    if args.continue_training:
        print("Llama 3.2 3B QLoRA継続学習を開始します...")
    else:
        print("Llama 3.2 3B QLoRA学習を開始します...")
    
    # チェックポイントから再開する場合
    if args.resume_from_checkpoint:
        print(f"チェックポイント '{args.resume_from_checkpoint}' から学習を再開します...")
        # 学習率を強制的に上書き（継続学習でのパラメータ反映問題の対策）
        trainer.args.learning_rate = args.learning_rate
        print(f"学習率を強制的に {args.learning_rate} に設定しました")
        # 学習状態をリセット（継続学習での学習完了状態問題の対策）
        trainer.args.max_steps = -1  # ステップ制限を解除
        trainer.args.num_train_epochs = args.epochs  # エポック数を再設定
        print(f"学習状態をリセット: max_steps=-1, epochs={args.epochs}")
        trainer.train(resume_from_checkpoint=args.resume_from_checkpoint)
    else:
        trainer.train()
    
    # モデルの保存
    print("モデルを保存中...")
    trainer.save_model(args.out)
    tokenizer.save_pretrained(args.out)
    
    if args.continue_training:
        print(f"Llama 3.2 3B QLoRA継続学習完了！モデルは {args.out} に保存されました。")
    else:
        print(f"Llama 3.2 3B QLoRA学習完了！モデルは {args.out} に保存されました。")

if __name__ == "__main__":
    main()
