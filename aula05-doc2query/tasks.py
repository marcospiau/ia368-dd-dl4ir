'''
Where to look for information:
 - https://github.com/google-research/text-to-text-transfer-transformer/issues/612
 - https://github.com/google-research/text-to-text-transfer-transformer/blob/master/t5/data/tasks.py#L42
 - https://github.com/google-research/text-to-text-transfer-transformer/issues/296
 - https://github.com/google-research/text-to-text-transfer-transformer/issues/299
'''
import functools
import seqio
import t5
import tensorflow as tf
from t5.data import preprocessors
from t5.data.tasks import DEFAULT_OUTPUT_FEATURES as T5_DEFAULT_OUTPUT_FEATURES
# from seqio import preprocessors
TaskRegistry = seqio.TaskRegistry
import sacrebleu

def bleu_manual(targets, predictions):
    bleu = sacrebleu.corpus_bleu(predictions, [targets]).score
    return {'bleu_manual': bleu}

# Tasks usando arquivos de texto direto
TaskRegistry.add(
    'doc2query_train',
    source=seqio.TextLineDataSource(
        split_to_filepattern={'train': 'train.tsv',
                              'validation': 'validation.tsv'},
        skip_header_lines=0,
        num_input_examples={'train': 10_000, 'validation': 1_000},
        caching_permitted=True,
        file_shuffle_buffer_size=None),
    preprocessors=[
        preprocessors.parse_tsv,
        seqio.preprocessors.tokenize,
        seqio.CacheDatasetPlaceholder(),
        seqio.preprocessors.append_eos_after_trim,
    ],
    output_features=T5_DEFAULT_OUTPUT_FEATURES,
    metric_fns=[t5.evaluation.metrics.bleu, bleu_manual])
