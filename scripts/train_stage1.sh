#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../training"

accelerate launch --config_file configs/accelerate_deepspeed.yaml train2.py \
--model_path "mistralai/Mistral-7B-v0.3" \
--dataset_name "Kamyar-zeinalipour/Protein-drug-v2" \
--subset None \
--data_column 'combined_seq' \
--split="train" \
--seq_length 1500 \
--max_steps 5300 \
--batch_size 4 \
--gradient_accumulation_steps 4 \
--learning_rate 5e-5  \
--lr_scheduler_type "cosine" \
--weight_decay 0.01 \
--num_warmup_steps 30 \
--eval_freq 50 \
--save_freq 5300  \
--log_freq 25 \
--num_workers 4 \
--bf16 \
--no_fp16  \
--output_dir "../outputs/stage1" \
--fim_rate 0.5 \
--fim_spm_rate 0.5 \
--use_flash_attn
