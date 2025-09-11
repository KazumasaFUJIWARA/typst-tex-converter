# データ管理ディレクトリ

## ディレクトリ構成

```
data/
├── teacher/                 # 教師データ
│   ├── tex/                # LaTeXファイル
│   ├── typst/              # Typstファイル
│   ├── train.jsonl         # 学習用データ
│   └── eval.jsonl          # 評価用データ
├── output/                 # モデル出力
│   ├── predictions/        # 予測結果
│   └── errors/             # エラー出力
├── correction/             # 修正データ
│   ├── manual/             # 手動修正
│   └── auto/               # 自動修正
├── processed/              # 前処理済みデータ
└── logs/                   # ログファイル
```

## 使用方法

### 1. 教師データの追加
```bash
# LaTeXファイルを追加
cp your_file.tex data/teacher/tex/

# Typstファイルを追加
cp your_file.typ data/teacher/typst/

# JSONLデータを追加
echo '{"system":"...","instruction":"...","input":"...","output":"..."}' >> data/teacher/train.jsonl
```

### 2. モデル出力の保存
```bash
# 予測結果を保存
cp model_output.jsonl data/output/predictions/

# エラー出力を保存
cp error_log.txt data/output/errors/
```

### 3. 修正データの管理
```bash
# 手動修正を保存
cp corrected_data.jsonl data/correction/manual/

# 自動修正を保存
cp auto_corrected.jsonl data/correction/auto/
```

## データ形式

### 教師データ (train.jsonl)
```json
{"system":"変換ルール","instruction":"LaTeX→Typst","input":"\\int_0^1 x dx","output":"∫_0^1 x d x"}
```

### 予測結果 (predictions/*.jsonl)
```json
{"input":"\\int_0^1 x dx","predicted":"∫_0^1 x d x","ground_truth":"∫_0^1 x d x","correct":true}
```

### 修正データ (correction/*.jsonl)
```json
{"original":"\\int_0^1 x dx","corrected":"∫_0^1 x d x","reason":"微分記号の修正"}
```
