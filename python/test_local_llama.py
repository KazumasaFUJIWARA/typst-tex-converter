#!/usr/bin/env python3
"""
ローカルのLlamaモデルをテストするスクリプト
"""

import torch
from transformers import pipeline

def main():
    print("ローカルのLlama 3.2-3B-Instructモデルをテスト中...")
    
    # ローカルのモデルパス
    model_id = "/mnt/d/lllm/llama32-3b"
    
    print(f"モデルパス: {model_id}")
    print("パイプラインを初期化中...")
    
    try:
        pipe = pipeline(
            "text-generation",
            model=model_id,
            dtype=torch.bfloat16,
            device_map="auto",
        )
        
        print("パイプライン初期化完了")
        
        messages = [
            {"role": "system", "content": "You are a pirate chatbot who always responds in pirate speak!"},
            {"role": "user", "content": "Who are you?"},
        ]
        
        print("メッセージを送信中...")
        print(f"システムメッセージ: {messages[0]['content']}")
        print(f"ユーザーメッセージ: {messages[1]['content']}")
        
        outputs = pipe(
            messages,
            max_new_tokens=256,
        )
        
        print("\n=== 生成結果 ===")
        print("完全な出力:")
        print(outputs[0]["generated_text"])
        
        print("\n=== 最後のメッセージのみ ===")
        print(outputs[0]["generated_text"][-1])
        
        print("\n=== アシスタントの応答のみ ===")
        assistant_response = outputs[0]["generated_text"][-1]["content"]
        print(assistant_response)
        
    except Exception as e:
        print(f"エラーが発生しました: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    main()
