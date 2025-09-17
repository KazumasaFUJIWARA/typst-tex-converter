# TeX ⇄ Typst 変換仕様書 v1.0

目的: Typst を **TeX ドラフト編集用の中間表現**として用いる。往復可逆性と人間可読性を最優先。

---

## 1. スコープ

* LaTeX 文書の一部構文を Typst へ決定的に写像。Typst 編集後に TeX へ厳密復元。
* 対象: 数式（アクセント・演算子・積分）、参照・引用、定理環境、整列、見出し、基本メタ。
* 非対象: TikZ、複雑なパッケージ独自構文。未知は退避。

## 2. 非機能要件

* 決定的出力。バージョン固定で同一入力→同一出力。
* ラウンドトリップ整合: `TeX → Typst → TeX` が**意味的同値**。
* 人間可読: 改行・空行・インデント規約を固定。
* 退避安全: 未対応はコメントで情報損失ゼロ。

## 3. 用語

* **正規化 ID**: `theorem:`, `eq:`, `fig:`, `table:`, `section:` 接頭辞付きラベル。

---

## 4. 入出力

### 4.1 TeX → Typst

* 入力: `.tex` UTF-8。
* 出力: `.typ` UTF-8。
* 変換方針: Unicode 合成を**原則不使用**。関数・構文で保持。

### 4.2 Typst → TeX

* 入力: `.typ`。
* 出力: `.tex`。原ラベル復元。未知は元構文へ。

---

## 5. 行末メタコメント

* 目的: typstからlatexへの復元時の精度を保障

### 5.1 数式のメタコメント

#### 文中式
``` latex
$ x^2 $
```
``` typst
$ x^2 $
```

#### 独立式
``` latex
	\[
	x^2
	\]
```
``` typst
	$
	x^2
	$ //[formula type:display]
```

#### 環境数式
``` latex
	\begin{align*}
	a &= b\\
	&= c
	\end{align*}
```
``` typst
	$
	a &= b\\
	&= c
	$ //[formula type:align*]
```

#### ラベル付き環境数式
``` latex
	\begin{align}
	a &= b \nonumber \\
	&= c \label{eq:test}
	\end{align}
```
``` typst
	$
	a &= b\\
	&= c
	$ //[formula type:align]
	<eq:test>
```

### 5.2 参照のメタコメント

#### 通常参照
``` latex
\ref{a}
```
``` typst
@a //[ref type:ref]
```

#### 数式参照
``` latex
\eqref{a}
```
``` typst
@a //[ref type:eqref]
```

#### 引用
``` latex
\cite{a,b}
```
``` typst
@a //[ref type:cite]
,
@b //[ref type:cite]
```

#### supplement付き参照
``` latex
Theorem \ref{theorem:aaaa}
```
``` typst
@theorem:aaaa //[ref type:ref supplement:Theorem]
```

---

## 6. 定理系

### 6.1 環境

* TeX: `\begin{theorem}[title]\label{lbl} ... \end{theorem}`
* Typst: `#theorem(id: "canon(lbl)", title: "title")[ ... ] //[Theorem]`
* オプション無しは `title` を省略。
* 派生環境（lemma, proposition, corollary）は同一写像で可。必要に応じ `#lemma` 等に割当可能（任意）。

---

## 7. 数式とトークン分割

### 7.1 アクセント（Unicode不使用）

* TeX: `\dot{x}`, `\ddot{x}`, `\hat{x}`, `\bar{x}`, `\tilde{x}`, `\vec{x}`
* Typst: `$ dot(x) $`, `$ ddot(x) $`, `$ hat(x) $`, `$ bar(x) $`, `$ tilde(x) $`, `$ vec(x) $`
* 添字: `\dot{x}_i` → `$ dot(x)_i $`。

### 7.2 変数の分離

* 規則: 数式中の変数は必ず空白で区切る。
* TeX: `\int_0^1 x dx` → Typst: `$ ∫_0^1 x d x $`
* TeX: `kf(x)` → Typst: `$ k f(x) $`
* 逆変換: 単独文字の変数は結合。`x d x` → `x dx`、`k f(x)` → `kf(x)`
* 例外: エスケープされた関数名は結合しない。`\sin(x)` は保持。

### 7.3 関数名の扱い

* 予約関数名（`\sin, \cos, \tan, \log, \ln, \exp, \sinh, \cosh, \erf` 等）はエスケープされているため分割不要。
* 多文字変数は分割しない（`kf_val` は保持）。

### 7.4 単独数式コマンド

* 単独の数式コマンドはUnicode変換を行う（合字以外）。
* 例: `\alpha` → `α`、`\beta` → `β`、`\gamma` → `γ`
* 例: `\infty` → `∞`、`\partial` → `∂`、`\nabla` → `∇`
* 例: `\mathfrak{A}` → `𝔄`、`\mathbb{R}` → `ℝ`、`\mathcal{L}` → `ℒ`
* 合字は保持: `\vec x` → `vec(x)`（Unicodeに変換しない）

### 7.5 演算子・総和積分

* 標準演算子は記号へ写像可能だが、**可逆性重視のため TeX コマンド名を維持**（推奨）。

  * 例: `\sum_{i=1}^n` → `$ Σ_(i=1)^n $`
  * 例: `\int_a^b` → `$ ∫_a^b $` も可だが、逆変換容易性を優先して `int` 関数表現も許容。

---

## 8. 見出し・メタ（article スタイル準拠）

### 8.1 タイトル等

* 複数のメタデータを統合:
```typst
#show: article.with(
  title: "論文タイトル",
  author: "著者名1 and 著者名2",
  affiliation: "所属機関1 and 所属機関2",
  abstract: "アブストラクト...",
  keywords: "キーワード1, キーワード2",
  date: "2024-01-01"
)
```

### 8.2 セクション

* `\section{S}` → `= S`
* `\subsection{S}` → `== S`
* 逆変換は対応する TeX コマンドに戻す。

### 8.3 メタデータの復元

* メタデータ（タイトル、著者等）の逆変換は完全対応していないため行わない。
* 元のLaTeXファイルのpreambleを保持することで対応。

### 8.4 Preamble の保持

* メタデータ系以外のpreambleはコメントアウトして文頭に保持:
```latex
\usepackage{amsmath}
\newcommand{\foo}{bar}
```
```typst
// \usepackage{amsmath}
// \newcommand{\foo}{bar}

#show: article.with(title: "論文タイトル")
...
```

---

## 9. 未知構文の扱い

* 未知マクロ: `\foo{...}` → `foo(...) //[latex:\foo]` として退避。
* 未知環境: 内容を素通しし、先頭に `/* env:NAME */` コメントを記録。
* 逆変換はコメント優先で原構文へ復元。

---

## 10. 整形規約（Pretty-print）

* ブロック構文:

  ```
  #theorem(id: "thm:aaaa", title: "Title")[
  	...
  ] //[theorem]
  ```
* インデント: タブ。
* 環境前後に空行不要。
* 80 桁目目安で折返し（句読点などで優先）。
* 数式行は `$ ... $` を1行に。独立式は行末コメントの書式に従う。
* 行末メタコメントは 1 スペース後に置く。

---

## 11. エラー処理

* 重大: ラベル参照未解決、整列群の破綻。→ 失敗として終了。
* 警告: 未知マクロ退避、ID 衝突の自動解決。→ 継続し Problems ログ出力。

---

## 12. 設定項目（推奨デフォルト）

* `tokenSplit.variables`: `on`（変数の空白分離）。
* `pretty.indent`: `tab | <number>`（デフォルト `tab`、数字の場合はスペース数）
* `pretty.blankLines`: `0`（環境前後に空行不要）。
* `pretty.lineLength`: `80`（折り返し目安）。
* `pretty.breakPriority`: `punctuation`（句読点優先）。

---

## 13. テスト規約

* ラウンドトリップ: 各ゴールドに対し
  `tex → typst → tex` が一致（空白規約込み）。
* カバレッジ: アクセント、変数分離、定理、cite/ref、未知退避。
* CI: 失敗時は PR ブロック。

---

## 14. VS Code/CI 統合（要点のみ）

* CLI: `tex2typst`, `typst2tex`, `roundtrip_check`。
* VS Code: コマンドとキー割当。保存時自動は任意。
* CI: 変更ファイルに対し `roundtrip_check` を実行。

---

## 15. バージョニング

* 変換ルール変更は `version` を上げ、行末メタコメントに記録。

---

## 16. セキュリティ

* ローカルで完結。外部呼出しなし。
* ファイルパスとラベルをログに出さない設定を既定。