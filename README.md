# LaTeX ↔ Typst Converter

LaTeXとTypst間の双方向変換を担うQLoRA用のJSONLファイルを生成するリポジトリです。

## 概要

このリポジトリは、LaTeXからTypstへの変換、およびTypstからLaTeXへの変換を学習するためのQLoRA（Quantized Low-Rank Adaptation）用の訓練データセットを作成します。

## 変換原則

### 事前命令（System Prompt）
```
Do not translate or paraphrase any natural language.

Preserve original whitespace and punctuation.

Only transform macros/syntax listed in the mapping table.

If a token is not in the table, copy it verbatim.

Never reorder text, figures, refs, or bibliography entries.

Validate that non-command spans are byte-identical to input.
```

### 変換例

#### LaTeX → Typst
```json
{"system":"変換原則: \\ref→@label, theorem環境→#theorem","instruction":"LaTeX→Typst","input":"\\begin{theorem}\\label{thm:main} A+B=C.\\end{theorem}","output":"#theorem[label: thm:main][A+B = C.]"}
```

```json
{"system":"変換原則: \\cite→@key","instruction":"LaTeX→Typst","input":"参考文献は \\cite{Smith2020} を参照。","output":"参考文献は @Smith2020 を参照。"}
```

#### Typst → LaTeX
```json
{"system":"変換原則: @label→\\ref, #theorem→theorem環境","instruction":"Typst→LaTeX","input":"#theorem[label: thm:main][A+B = C.]","output":"\\begin{theorem}\\label{thm:main} A+B=C.\\end{theorem}"}
```

## データ形式

各JSONLファイルの各行は以下の形式のJSONオブジェクトです：

```json
{
  "system": "変換原則の説明",
  "instruction": "変換方向（LaTeX→Typst または Typst→LaTeX）",
  "input": "入力テキスト",
  "output": "期待される出力テキスト"
}
```

## データセット

このリポジトリには、詳細な変換規則に基づいて作成されたQLoRA用のJSONLファイルが含まれています：

- **train.jsonl** - 学習用データ（約85%）
- **eval.jsonl** - 評価用データ（約15%）

### データセットの特徴

- **包括的な変換規則**: 微分記号、数学演算子、数式環境、定理環境、参考文献など
- **Unicode記号の活用**: 数学記号をUnicode記号に変換（∈, ≤, ≥, ∫, ∑, ∏など）
- **複雑な数式対応**: 多重積分、高階微分、テイラー級数、行列など
- **定理環境の完全対応**: Theorem, Lemma, Definition, Proof, Remark, Corollary, Proposition
- **参考文献システム**: 引用、参考文献リスト、複数bibファイル対応
- **エラー回避**: よくあるエラーパターンとその修正方法を含む

### データ形式

各JSONLファイルの各行は以下の形式のJSONオブジェクトです：

```json
{
  "system": "変換原則の説明",
  "instruction": "変換方向（LaTeX→Typst または Typst→LaTeX）",
  "input": "入力テキスト",
  "output": "期待される出力テキスト"
}
```

## 使用方法

1. リポジトリをクローン
2. 必要な依存関係をインストール
3. 提供されたJSONLファイルをQLoRA訓練に使用
4. 必要に応じて追加のデータ生成スクリプトを実行

## ライセンス

[ライセンス情報を追加]

## 貢献

プルリクエストやイシューの報告を歓迎します。