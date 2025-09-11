# Typst-Tex Converter QLoRA Training

LaTeXからTypstへの変換を学習するQLoRAモデルのトレーニングプロジェクトです。

## ディレクトリ構成

```
├── python/           # Pythonスクリプト
│   ├── train_llama32_3b_qlora_fixed.py # Llama 3.2 3B専用学習
│   ├── inference_llama32_3b.py # 推論スクリプト
│   └── requirements.txt    # 依存関係
├── jsonl/            # 学習データ
│   ├── train_001.jsonl     # 学習データ（初期バージョン）
│   ├── train_002.jsonl     # 学習データ（最新バージョン）
│   ├── eval.jsonl          # 評価データ
│   └── README.md           # バージョン管理ドキュメント
├── sample/           # テスト用LaTeXファイル
│   └── sample_small.tex    # サンプルLaTeXファイル
├── trained/          # 変換結果
│   ├── 001.typ            # 001モデルの変換結果
│   ├── 002.typ            # 002モデルの変換結果
│   └── 001_test.typ       # テスト結果
└── outputs/          # 学習済みモデル（自動生成）
    ├── llama32-3b-typst-qlora-001/ # バージョン001の学習済みモデル
    ├── llama32-3b-typst-qlora-002/ # バージョン002の学習済みモデル
    └── llama32-3b-typst-qlora-full/ # 既存の学習済みモデル
```

## 基本的な流れ

### 1. 環境セットアップ
```bash
# 仮想環境を有効化
source venv/bin/activate
```

### 2. テスト（現在のモデルで変換テスト）
```bash
# 既存モデルでテスト
python python/inference_llama32_3b.py \
  --input_file sample/sample_small.tex \
  --output_file trained/current_test.typ \
  --peft_model_path outputs/llama32-3b-typst-qlora-full \
  --no-chunking
```

### 3. JSONL作成（問題点を特定して学習データを改善）
```bash
# 学習データの確認
ls -la jsonl/
cat jsonl/README.md

# 必要に応じて学習データを修正
# train_001.jsonl, train_002.jsonl などを編集
```

### 4. 継続学習（段階的に改善）
```bash
# 001で新規学習（チェックポイント保存付き）
python python/train_llama32_3b_qlora_fixed.py \
  --data jsonl/train_001.jsonl \
  --out outputs/llama32-3b-typst-qlora-001 \
  --epochs 10 \
  --batch_size 2 \
  --grad_accum 8 \
  --learning_rate 2e-4 \
  --lora_r 8 \
  --lora_alpha 16 \
  --lora_dropout 0.1

# チェックポイントの確認
ls -la outputs/llama32-3b-typst-qlora-001/

# 002で継続学習（001の最新チェックポイントから継続）
python python/train_llama32_3b_qlora_fixed.py \
  --data jsonl/train_002.jsonl \
  --out outputs/llama32-3b-typst-qlora-002 \
  --resume_from_checkpoint outputs/llama32-3b-typst-qlora-001/checkpoint-XXX \
  --epochs 10 \
  --batch_size 2 \
  --grad_accum 8 \
  --learning_rate 2e-4 \
  --lora_r 8 \
  --lora_alpha 16 \
  --lora_dropout 0.1
```

### 5. テスト（改善結果を確認）
```bash
# 001モデルでテスト
python python/inference_llama32_3b.py \
  --input_file sample/sample_small.tex \
  --output_file trained/001_test.typ \
  --peft_model_path outputs/llama32-3b-typst-qlora-001 \
  --no-chunking

# 002モデルでテスト
python python/inference_llama32_3b.py \
  --input_file sample/sample_small.tex \
  --output_file trained/002_test.typ \
  --peft_model_path outputs/llama32-3b-typst-qlora-002 \
  --no-chunking
```

## 詳細設定

### 学習パラメータ
```bash
# 基本パラメータ
--epochs 10              # エポック数
--batch_size 2           # バッチサイズ
--grad_accum 8           # 勾配累積
--learning_rate 2e-4     # 学習率
--lora_r 8               # LoRA rank
--lora_alpha 16          # LoRA alpha
--lora_dropout 0.1       # LoRA dropout
```

### チェックポイント管理
```bash
# チェックポイントの確認
ls -la outputs/llama32-3b-typst-qlora-001/

# チェックポイントの内容確認
ls -la outputs/llama32-3b-typst-qlora-001/checkpoint-XXX/

# 最新チェックポイントから継続学習
python python/train_llama32_3b_qlora_fixed.py \
  --data jsonl/train_002.jsonl \
  --out outputs/llama32-3b-typst-qlora-002 \
  --resume_from_checkpoint outputs/llama32-3b-typst-qlora-001/checkpoint-XXX \
  --epochs 10 \
  --batch_size 2 \
  --grad_accum 8 \
  --learning_rate 2e-4 \
  --lora_r 8 \
  --lora_alpha 16 \
  --lora_dropout 0.1
```

### チェックポイント保存設定
- **save_steps=50**: 50ステップごとにチェックポイント保存
- **save_total_limit=5**: 最新5つのチェックポイントのみ保持
- **save_strategy="steps"**: ステップベースで保存

## トラブルシューティング

### よくある問題

#### 1. メモリ不足
```bash
# バッチサイズを削減
--batch_size 1

# 勾配累積を増加
--grad_accum 16

# LoRA rankを削減
--lora_r 4
```

#### 2. 学習が発散する場合
```bash
# 学習率を削減
--learning_rate 1e-4

# dropoutを増加
--lora_dropout 0.2
```

#### 3. 生成品質が悪い場合
```bash
# エポック数を増加
--epochs 15

# 学習データの品質を確認
cat jsonl/README.md
```

## ハイパーパラメータ

### 推奨設定

#### Llama 3.2 3B専用（8GB VRAM）
- **量子化**: 4bit NF4
- **LoRA**: r=8, alpha=16, dropout=0.1
- **対象層**: 全層（q_proj, v_proj, k_proj, o_proj, gate_proj, up_proj, down_proj）
- **バッチサイズ**: 2
- **勾配累積**: 8
- **学習率**: 2e-4
- **最大長**: 1024
- **エポック数**: 5

#### LLaMA 3 8B専用（8GB VRAM）
- **量子化**: 4bit NF4
- **LoRA**: r=16, alpha=32, dropout=0.1
- **対象層**: 全層（q_proj, v_proj, k_proj, o_proj, gate_proj, up_proj, down_proj）
- **バッチサイズ**: 1
- **勾配累積**: 16
- **学習率**: 1e-4
- **最大長**: 2048

#### 汎用設定（8GB VRAM）
- **量子化**: 4bit NF4
- **LoRA**: r=8, alpha=16, dropout=0.1
- **対象層**: q_proj, v_proj
- **バッチサイズ**: 1
- **勾配累積**: 32
- **学習率**: 2e-4
- **最大長**: 1024

### メモリ不足の場合

- 最大長を512に削減
- LoRA rankを4に削減
- 勾配累積を64に増加

## データ形式

### 新しい推奨形式（train_v2.jsonl）

```json
{
  "prompt": [
    {
      "role": "user",
      "content": "LaTeXをTypstに変換してください: \\int_0^1 x dx = \\sum_{i=1}^n x_i \\in \\RR"
    }
  ],
  "completion": [
    {
      "role": "assistant",
      "content": "∫_0^1 x d x = ∑_(i=1)^n x_i ∈ ℝ"
    }
  ]
}
```

### 従来形式（train.jsonl）

```json
{"system":"変換ルールの説明","instruction":"LaTeX→Typst","input":"\\int_0^1 x dx","output":"∫_0^1 x d x"}
```

### 前処理後形式

```json
{"text":"システム: 変換ルールの説明\n\n指示: LaTeX→Typst\n\n入力: \\int_0^1 x dx\n\n出力: ∫_0^1 x d x"}
```

## トラブルシューティング

### メモリ不足

1. `max_len` を512に削減
2. `batch_size` を1に設定
3. `grad_accum` を増加
4. LoRA rankを削減

### 学習が発散する場合

1. 学習率を1e-4に削減
2. `max_grad_norm` を1.0に設定
3. dropoutを0.2に増加

### 生成品質が悪い場合

1. 学習データの品質を確認
2. プロンプト形式を統一
3. エポック数を増加

## バージョン管理ポリシー

### ファイル命名規則

#### 学習データ
- `train_001.jsonl` - 初期バージョン
- `train_002.jsonl` - 最新バージョン
- `train_003.jsonl` - 次期バージョン

#### 出力モデル
- `outputs/llama32-3b-typst-qlora-002/` - バージョン002の学習済みモデル
- `outputs/llama32-3b-typst-qlora-003/` - バージョン003の学習済みモデル

#### 命名規則
- **学習データ**: `train_XXX.jsonl` (3桁の連番)
- **出力モデル**: `llama32-3b-typst-qlora-XXX` (3桁の連番)
- **snake_caseの補足は使用しない**

### バージョン管理

#### 学習データの更新
1. 新しいバージョンを作成する際は、次の連番を使用
2. `jsonl/README.md`に各バージョンの特徴を記録
3. 修正は同一ファイル内で行う（別ファイル作成を避ける）

#### モデル出力の管理
1. 学習実行時は適切なバージョン番号を指定
2. 古いバージョンは必要に応じてアーカイブ
3. 最新バージョンは明確に識別可能にする

#### 継続学習の流れ
1. **001**: ベースモデル → `train_001.jsonl` → `outputs/llama32-3b-typst-qlora-001`
2. **002**: 001モデル → `train_002.jsonl` → `outputs/llama32-3b-typst-qlora-002`
3. **003**: 002モデル → `train_003.jsonl` → `outputs/llama32-3b-typst-qlora-003`
4. 各段階でテストを実行し、改善点を特定

#### 継続学習の例
```bash
# バージョン001で新規学習
python python/train_llama32_3b_qlora_fixed.py \
  --data jsonl/train_001.jsonl \
  --out outputs/llama32-3b-typst-qlora-001 \
  --epochs 10

# バージョン002で継続学習（001から継続）
python python/train_llama32_3b_qlora_fixed.py \
  --data jsonl/train_002.jsonl \
  --out outputs/llama32-3b-typst-qlora-002 \
  --resume_from_checkpoint outputs/llama32-3b-typst-qlora-001/checkpoint-XXX \
  --epochs 10

# バージョン003で継続学習（002から継続）
python python/train_llama32_3b_qlora_fixed.py \
  --data jsonl/train_003.jsonl \
  --out outputs/llama32-3b-typst-qlora-003 \
  --resume_from_checkpoint outputs/llama32-3b-typst-qlora-002/checkpoint-XXX \
  --epochs 10
```

#### テストコマンド
```bash
# 001モデルでテスト
python python/inference_llama32_3b.py \
  --input_file sample/sample_small.tex \
  --output_file trained/001_test.typ \
  --peft_model_path outputs/llama32-3b-typst-qlora-001 \
  --no-chunking

# 002モデルでテスト
python python/inference_llama32_3b.py \
  --input_file sample/sample_small.tex \
  --output_file trained/002_test.typ \
  --peft_model_path outputs/llama32-3b-typst-qlora-002 \
  --no-chunking
```

## ライセンス

このプロジェクトはMITライセンスの下で公開されています。