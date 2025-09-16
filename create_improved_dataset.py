#!/usr/bin/env python3
"""
改良版学習データセット作成スクリプト
train_002.jsonlの問題点を修正し、より効果的な学習データを作成
"""

import json
import os

def create_improved_dataset():
    """改良版データセットを作成"""
    
    # 基本記号変換データ（train_004から）
    basic_symbols = [
        {"input": "\\partial", "output": "∂"},
        {"input": "\\Delta", "output": "Δ"},
        {"input": "\\mathbb{R}", "output": "ℝ"},
        {"input": "\\in", "output": "∈"},
        {"input": "\\leq", "output": "≤"},
        {"input": "\\geq", "output": "≥"},
        {"input": "\\neq", "output": "≠"},
        {"input": "\\infty", "output": "∞"},
        {"input": "\\emptyset", "output": "∅"},
        {"input": "\\rightarrow", "output": "→"},
        {"input": "\\leftarrow", "output": "←"},
        {"input": "\\sum", "output": "∑"},
        {"input": "\\int", "output": "∫"},
        {"input": "\\prod", "output": "∏"},
        {"input": "\\alpha", "output": "α"},
        {"input": "\\beta", "output": "β"},
        {"input": "\\gamma", "output": "γ"},
        {"input": "\\delta", "output": "δ"},
        {"input": "\\epsilon", "output": "ε"},
        {"input": "\\theta", "output": "θ"},
        {"input": "\\lambda", "output": "λ"},
        {"input": "\\mu", "output": "μ"},
        {"input": "\\pi", "output": "π"},
        {"input": "\\sigma", "output": "σ"},
        {"input": "\\tau", "output": "τ"},
        {"input": "\\phi", "output": "φ"},
        {"input": "\\psi", "output": "ψ"},
        {"input": "\\omega", "output": "ω"},
    ]
    
    # 数式構造変換データ
    math_structures = [
        {
            "input": "\\begin{align}\\label{eq:test}\\partial_t^2 u + \\partial_t u - \\Delta u = |u|^p\\end{align}",
            "output": "$ \\partial_t^2 u + \\partial_t u - \\Delta u = |u|^p $ <eq:test>"
        },
        {
            "input": "\\begin{cases}\\partial_t^2 u + \\partial_t u - \\Delta u = |u|^p, & t > 0, x \\in \\mathbb{R}^n,\\\\u(0) = u_0, \\partial_t u(0) = u_1, & x \\in \\mathbb{R}^n.\\end{cases}",
            "output": "$ cases(\n  \\partial_t^2 u + \\partial_t u - \\Delta u = |u|^p, & t > 0, x \\in \\mathbb{R}^n,\n  u(0) = u_0, \\partial_t u(0) = u_1, & x \\in \\mathbb{R}^n.\n) $"
        },
        {
            "input": "\\begin{align}\\label{eq:initial}(u_0, u_1) = (\\varepsilon_0 \\varphi, \\varepsilon_1 \\varphi)\\end{align}",
            "output": "$ (u_0, u_1) = (\\varepsilon_0 \\varphi, \\varepsilon_1 \\varphi) $ <eq:initial>"
        }
    ]
    
    # 文書構造変換データ
    document_structures = [
        {
            "input": "\\section{Introduction}",
            "output": "= Introduction"
        },
        {
            "input": "\\subsection{Basic Concepts}",
            "output": "== Basic Concepts"
        },
        {
            "input": "\\subsubsection{Properties}",
            "output": "=== Properties"
        },
        {
            "input": "\\title{Mathematical Analysis}",
            "output": "#set page(title: \"Mathematical Analysis\")"
        },
        {
            "input": "\\author{Author Name}",
            "output": "#set page(author: \"Author Name\")"
        }
    ]
    
    # 統合データセットを作成
    improved_data = []
    
    # 基本記号変換を追加
    for item in basic_symbols:
        improved_data.append({
            "prompt": [{"role": "user", "content": f"LaTeXをTypstに変換してください: {item['input']}"}],
            "completion": [{"role": "assistant", "content": item['output']}]
        })
    
    # 数式構造変換を追加
    for item in math_structures:
        improved_data.append({
            "prompt": [{"role": "user", "content": f"LaTeXをTypstに変換してください: {item['input']}"}],
            "completion": [{"role": "assistant", "content": item['output']}]
        })
    
    # 文書構造変換を追加
    for item in document_structures:
        improved_data.append({
            "prompt": [{"role": "user", "content": f"LaTeXをTypstに変換してください: {item['input']}"}],
            "completion": [{"role": "assistant", "content": item['output']}]
        })
    
    # ファイルに保存
    output_file = "jsonl/train_002_improved.jsonl"
    with open(output_file, 'w', encoding='utf-8') as f:
        for item in improved_data:
            f.write(json.dumps(item, ensure_ascii=False) + '\n')
    
    print(f"改良版データセットを作成しました: {output_file}")
    print(f"データ数: {len(improved_data)}件")
    print(f"- 基本記号変換: {len(basic_symbols)}件")
    print(f"- 数式構造変換: {len(math_structures)}件")
    print(f"- 文書構造変換: {len(document_structures)}件")

if __name__ == "__main__":
    create_improved_dataset()
