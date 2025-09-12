# 学習データバージョン管理

## ファイル構成

- `train_001.jsonl` - 初期バージョン（95件）
- `train_002.jsonl` - 最新バージョン（95件）
- `train_003.jsonl` - 複雑な構造変換版（20件）
- `train_004.jsonl` - 基本記号変換版（20件）
- `eval.jsonl` - 評価用データ（97件）

## 各バージョンの特徴

### train_001.jsonl
- **重視点**: 基本的な数式変換
- **内容**: 短い数式のLaTeX→Typst変換
- **例**: `\int_0^1 x dx = \sum_{i=1}^n x_i \in \RR` → `∫_0^1 x d x = ∑_(i=1)^n x_i ∈ ℝ`
- **問題点**: 全文変換例なし、不正なコマンド（`\RR`等）を含む

### train_002.jsonl
- **重視点**: 標準的なLaTeXコマンドの使用
- **内容**: 基本的な数式変換（標準コマンド版）
- **例**: `\int_0^1 x dx = \sum_{i=1}^n x_i \in \mathbb{R}` → `∫_0^1 x d x = ∑_(i=1)^n x_i ∈ ℝ`
- **改善点**: 不正なコマンドを修正（`\RR` → `\mathbb{R}`）
- **問題点**: 全文変換例なし

### train_003.jsonl
- **重視点**: 複雑な構造変換
- **内容**: align、cases、theorem、proof等の複雑なLaTeX構造
- **例**: `\begin{align}\label{eq:DW}\begin{cases}\partial_t^2 u+\partial_t u-\Delta u=|u|^p\end{cases}\end{align}` → `$ cases( ∂_t^2 u + ∂_t u - Δ u = |u|^p ) $ <eq:DW>`
- **問題点**: 学習が困難、継続学習でも改善されない

### train_004.jsonl
- **重視点**: 基本記号変換の確実な学習
- **内容**: 単一記号のLaTeX→Unicode変換
- **例**: `\partial` → `∂`, `\Delta` → `Δ`, `\mathbb{R}` → `ℝ`
- **戦略**: 複雑な構造より基本記号変換を優先
- **目的**: 003で失敗した基本変換を確実に学習

## 推奨使用

**基本学習用**: `train_004.jsonl`（基本記号変換）
**構造学習用**: `train_003.jsonl`（複雑な構造変換）
**評価用**: `eval.jsonl`

## 学習戦略

1. **段階1**: `train_004.jsonl`で基本記号変換を確実に学習
2. **段階2**: 基本変換が成功したら`train_003.jsonl`で構造変換を学習
3. **段階3**: 最終的に`train_002.jsonl`で総合的な変換を学習

## 今後の改善予定

1. 全文変換例の追加
2. 構造変換の改善（`\section{}` → `= `）
3. Unicode変換の強化（`\partial` → `∂`、`\Delta` → `Δ`）
4. ベクトル記法の修正（`\vec{}` → `arrow()`、`\mathbf{}` → `bold()`）
