pip install jupyter notebook
pip install --upgrade jupyter_http_over_ws>=0.0.7 &&   jupyter serverextension enable --py jupyter_http_over_ws
pip install polars toolz cytoolz matplotlib pyarrow ray[default] more-itertools