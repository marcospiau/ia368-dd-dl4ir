# Contents

- `01-baseline-monot5-base-castorini.ipynb`: pipeline validation using castorini code
- `02-baseline-monot5-base-likelihood-scoring.ipynb`: pipeline using t5 score_eval mode
- `03_synthetic_data_generation.ipynb`: sinthetic data generatin pipeline

# Results (so far)
- BM25: `{'recip_rank': '0.8529', 'recall_1000': '0.3955', 'ndcg_cut_10': '0.5947'}`
- monot5-base castorini default: `{'recip_rank': '0.8607', 'recall_1000': '0.3955', 'ndcg_cut_10': '0.7178'}`
- monot5-base score_eval mode (likelihood): `{'recip_rank': '0.8585', 'recall_1000': '0.3955', 'ndcg_cut_10': '0.7174'}`
