export PYTHONPATH="${PYTHONPATH}:./"
set -u # or set -o nounset

# This env var should be already set
# BUCKET=gs://marcospiau-doc2query-aula05
echo ${BUCKET}

ZONE=us-central1-f
# TPU_NAME=local this is already set on colab
TPU_SIZE=v2-8
TFDS_DATA_DIR=${BUCKET}/tensorflow_datasets
CACHE_TASKS_DIR=${BUCKET}/cache_tasks

MODEL_DIR=${BUCKET}/models/doc2query_train

echo MODEL_DIR=$MODEL_DIR

LOG_FILE=train_log.log
echo $LOG_FILE
echo LOG_FILE log file is $LOG_FILE

echo -e "*****pip requirements*****\n$(pip freeze)" > $LOG_FILE
(time python3 -m t5.models.mesh_transformer_main  \
--tpu_zone="${ZONE}" \
--tpu="${TPU_NAME}" \
--model_dir="${MODEL_DIR}" \
--t5_tfds_data_dir="${TFDS_DATA_DIR}" \
--additional_task_cache_dirs="${CACHE_TASKS_DIR}" \
--module_import="tasks" \
--gin_param="utils.tpu_mesh_shape.tpu_topology = '${TPU_SIZE}'" \
--gin_file="train_configs.gin" \
$@ ) 2>&1 | tee -a $LOG_FILE

FINAL_LOG_FILE=${MODEL_DIR}/train.log
echo Final log file is $FINAL_LOG_FILE
gsutil cp $LOG_FILE $FINAL_LOG_FILE
