#!/usr/bin/env python3
"""
メモリ監視スクリプト
学習中のメモリ使用量を監視し、閾値を超えた場合に警告を出力
"""

import psutil
import time
import subprocess
import sys

def get_gpu_memory():
    """GPUメモリ使用量を取得"""
    try:
        result = subprocess.run(['nvidia-smi', '--query-gpu=memory.used,memory.total', '--format=csv,noheader,nounits'], 
                              capture_output=True, text=True)
        if result.returncode == 0:
            used, total = result.stdout.strip().split(', ')
            return int(used), int(total)
    except:
        pass
    return None, None

def monitor_memory(ram_threshold=80, gpu_threshold=90, interval=30):
    """
    メモリ使用量を監視
    
    Args:
        ram_threshold: RAM使用率の閾値（%）
        gpu_threshold: GPU使用率の閾値（%）
        interval: 監視間隔（秒）
    """
    print(f"メモリ監視開始 - RAM閾値: {ram_threshold}%, GPU閾値: {gpu_threshold}%, 間隔: {interval}秒")
    
    while True:
        try:
            # RAM使用量
            ram = psutil.virtual_memory()
            ram_percent = ram.percent
            
            # GPU使用量
            gpu_used, gpu_total = get_gpu_memory()
            gpu_percent = (gpu_used / gpu_total * 100) if gpu_used and gpu_total else 0
            
            # ログ出力
            timestamp = time.strftime("%Y-%m-%d %H:%M:%S")
            print(f"[{timestamp}] RAM: {ram_percent:.1f}% ({ram.used/1024**3:.1f}GB/{ram.total/1024**3:.1f}GB), "
                  f"GPU: {gpu_percent:.1f}% ({gpu_used}MB/{gpu_total}MB)")
            
            # 警告チェック
            if ram_percent > ram_threshold:
                print(f"⚠️  RAM使用率が閾値を超過: {ram_percent:.1f}% > {ram_threshold}%")
            
            if gpu_percent > gpu_threshold:
                print(f"⚠️  GPU使用率が閾値を超過: {gpu_percent:.1f}% > {gpu_threshold}%")
            
            time.sleep(interval)
            
        except KeyboardInterrupt:
            print("\n監視を終了します")
            break
        except Exception as e:
            print(f"監視エラー: {e}")
            time.sleep(interval)

if __name__ == "__main__":
    import argparse
    
    parser = argparse.ArgumentParser(description="メモリ監視スクリプト")
    parser.add_argument("--ram-threshold", type=int, default=80, help="RAM使用率の閾値（%）")
    parser.add_argument("--gpu-threshold", type=int, default=90, help="GPU使用率の閾値（%）")
    parser.add_argument("--interval", type=int, default=30, help="監視間隔（秒）")
    
    args = parser.parse_args()
    
    monitor_memory(args.ram_threshold, args.gpu_threshold, args.interval)
