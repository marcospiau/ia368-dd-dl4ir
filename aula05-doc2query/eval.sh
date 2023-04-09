set -u
DECODING_METHOD=$1

# This env var should be already set
echo ${BUCKET}

ZONE=us-central1-f
# TPU_NAME=local this is already set on colab
TPU_SIZE=v2-8
CACHE_TASKS_DIR=${BUCKET}/cache_tasks

MODEL_DIR=${BUCKET}/models/doc2query_train

echo MODEL_DIR=$MODEL_DIR
LOG_FILE=eval_log_${DECODING_METHOD}.log
echo LOG_FILE log file is $LOG_FILE

export MODEL_DIR=gs://marcospiau-doc2query-aula05/models/doc2query_train

# --gin_param="MIXTURE_NAME = '${MIXTURE_NAME}'"
# MIXTURE_NAME and sequence_length are already defined in operative_config.gin

echo "*****decoding_method*****" $DECODING_METHOD
(time python3 -m t5.models.mesh_transformer_main  \
--tpu_zone="${ZONE}" \
--tpu="${TPU_NAME}" \
--model_dir="${MODEL_DIR}" \
--gin_file="${MODEL_DIR}/operative_config.gin" \
--gin_file="${DECODING_METHOD}.gin" \
--additional_task_cache_dirs="${CACHE_TASKS_DIR}" \
--gin_file="eval.gin" \
--module_import="tasks" \
--gin_param="run.eval_dir_suffix = '${DECODING_METHOD}'" \
--gin_param="eval_checkpoint_step = 'all'" \
--gin_param="run.dataset_split = 'validation'" \
--gin_param="utils.run.sequence_length = None" \
--gin_param="utils.run.batch_size = (\"sequences_per_batch\", 512)" \
--gin_param="utils.run.eval_dataset_fn = @t5.models.mesh_transformer.mesh_eval_dataset_fn" \
--gin_param="mesh_eval_dataset_fn.use_cached = True" \
) 2>&1 | tee $LOG_FILE

FINAL_LOG_FILE=${MODEL_DIR}/${LOG_FILE}
echo Final log file is $FINAL_LOG_FILE
gsutil cp $LOG_FILE $FINAL_LOG_FILE
