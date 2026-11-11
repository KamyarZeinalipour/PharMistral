#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../training"

accelerate launch --config_file configs/accelerate_deepspeed.yaml train2.py \
--model_path "outputs/stage1/checkpoint-5300" \
--dataset_name "Kamyar-zeinalipour/Protein-drug-pair-v2" \
--subset None \
--data_column 'sequence' \
--split="train" \
--seq_length 1500 \
--max_steps 5000 \
--batch_size 4 \
--gradient_accumulation_steps 4 \
--learning_rate 5e-5  \
--lr_scheduler_type "cosine" \
--weight_decay 0.01 \
--num_warmup_steps 30 \
--eval_freq 50 \
--save_freq 5000  \
--log_freq 25 \
--num_workers 4 \
--bf16 \
--no_fp16  \
--output_dir "../outputs/stage2" \
--fim_rate 0.5 \
--fim_spm_rate 0.5 \
--use_flash_attn
