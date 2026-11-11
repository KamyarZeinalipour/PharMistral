# PharMistral

**Sequence-conditioned ligand generation for protein targets with Mistral-7B**

[![Paper](https://img.shields.io/badge/CMPB_Update_2026-paper-b31b1b)](https://doi.org/10.1016/j.cmpbup.2026.100257)
[![Collection](https://img.shields.io/badge/%F0%9F%A4%97_Collection-PharMistral-orange)](https://huggingface.co/collections/Kamyar-zeinalipour/pharmistral-cmpb-update-2026-6af48fca521e8481db608782)
[![License](https://img.shields.io/badge/code-Apache_2.0-blue)](LICENSE)

Designing molecules for protein targets that lack abundant data or a solved 3D structure is hard,
because most models need known binders or pocket geometry. **PharMistral** takes a different route:
a single 7B-parameter language model is adapted to read protein sequences and write candidate
ligands, with no target-specific retraining and no structural input.

This repository accompanies [*PharMistral: Drug generation for novel protein targets by Mistral
Large Language Model*](https://doi.org/10.1016/j.cmpbup.2026.100257) (Computer Methods and Programs in Biomedicine Update, 2026, open
access) and contains the training code and launchers. The models, tokenizer and datasets are in the
[PharMistral collection](https://huggingface.co/collections/Kamyar-zeinalipour/pharmistral-cmpb-update-2026-6af48fca521e8481db608782).

## Method

Training has two stages:

1. **Joint pre-training** on unpaired data — over 300,000 human protein sequences and more than a
   million drug-like molecules — so that one model learns a shared representation of both.
2. **Sequence-conditioned fine-tuning** on roughly 300,000 high-affinity protein–ligand pairs
   curated from ChEMBL-26.

Both stages use the Mistral-7B SentencePiece vocabulary, sequences up to 1,500 tokens, and
fill-in-the-middle augmentation.

## Released artifacts

| Artifact | |
|---|---|
| [mistral-7b-drug-prots](https://huggingface.co/Kamyar-zeinalipour/mistral-7b-drug-prots) | Stage I: Mistral-7B after joint pre-training on protein sequences and small molecules |
| [mistral-7b-drug-prots_pair](https://huggingface.co/Kamyar-zeinalipour/mistral-7b-drug-prots_pair) | Stage II: the final sequence-conditioned model |
| [drug-prot-tokenizer-v2-mistral](https://huggingface.co/Kamyar-zeinalipour/drug-prot-tokenizer-v2-mistral) | Tokenizer used for both stages |
| [Protein-drug-v2](https://huggingface.co/datasets/Kamyar-zeinalipour/Protein-drug-v2) | Stage I data: unpaired protein and small-molecule sequences |
| [Protein-drug-pair-v2](https://huggingface.co/datasets/Kamyar-zeinalipour/Protein-drug-pair-v2) | Stage II data: high-affinity protein–ligand pairs from ChEMBL-26 |

## Reported results

On held-out protein targets the model produced **99.5% chemically valid** molecules. Of the valid
molecules 57% were unique, and 36% of those were novel with respect to the training set. After
drug-likeness and toxicity filtering, 3,383 unique molecules remained. The paper also compares
binding-affinity estimates against DeepTarget and reports ADMET profiling; see the
[paper](https://doi.org/10.1016/j.cmpbup.2026.100257) for the full analysis.

## Training

```bash
pip install -r requirements.txt
scripts/train_stage1.sh     # joint pre-training
scripts/train_stage2.sh     # sequence-conditioned fine-tuning
```

Settings as used for the released checkpoints: 4 GPUs, sequence length 1,500, batch size 4 with 4
gradient-accumulation steps, learning rate 5e-5 with cosine decay and 30 warm-up steps,
fill-in-the-middle rate 0.5; 5,300 steps for Stage I and 5,000 for Stage II.

## Intended use

Research use only. Generated molecules are computational hypotheses: they have not been
synthesised or tested experimentally, and they require the usual medicinal-chemistry, safety and
regulatory evaluation before any practical use.

## Citation

```bibtex
@article{bendjeddou2026pharmistral,
  title   = {PharMistral: Drug generation for novel protein targets by Mistral Large Language Model},
  author  = {Asma Bendjeddou and Kamyar Zeinalipour and Dalal Bardou and Marco Maggini and Franco Scarselli and Monica Bianchini},
  journal = {Computer Methods and Programs in Biomedicine Update},
  volume  = {10},
  pages   = {100257},
  year    = {2026},
  doi     = {10.1016/j.cmpbup.2026.100257}
}
```

## License

Code: [Apache License 2.0](LICENSE). The paper is open access under CC BY-NC-ND 4.0; the models
follow the license of Mistral-7B.
