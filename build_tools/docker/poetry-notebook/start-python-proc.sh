#!/usr/bin/env bash

set -e
# if [ "$RUN_STREAMLIT" == "yes" ]; then
#     poetry run streamlit run $HOME/work/src/apps/$STREAMLIT_APP_NAME &
# fi
# if [ "$RUN_DASHBOARD" == "yes" ]; then
#     poetry run explainerhub run $HOME/work/apps/explainerhub/$DASHBOARD_CONFIG_NAME &
# fi
poetry run jupyter lab 
