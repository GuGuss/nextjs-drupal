#!/usr/bin/env bash
########################################################################################################################
# NOTE:
# 
# Like most decoupled Drupal implementations, this demo relies on pathauto to define a pattern every newly created node
#   will follow when generating path aliases. This script sets up that pattern, and also generates dummy content.
# 
# In both cases, small Drush scripts have been written that are called.
#
########################################################################################################################

# 1. Setup pathauto aliases.
printf "    ✔ Defining node aliases via pathauto (see https://next-drupal.org/learn/quick-start/configure-content-types).\n"
TYPE=$(cat $ENV_SETTINGS | jq -r '.project.nodes.pathauto.type')
BUNDLE=$(cat $ENV_SETTINGS | jq -r '.project.nodes.pathauto.bundle')
LABEL=$(cat $ENV_SETTINGS | jq -r '.project.nodes.pathauto.label')
PATTERN=$(cat $ENV_SETTINGS | jq -r '.project.nodes.pathauto.pattern')
printf "        * type: $TYPE\n"
printf "        * bundle: $BUNDLE\n"
printf "        * label: $LABEL\n"
printf "        * pattern: $PATTERN\n"
drush scr $DRUPAL_SETUP/project/04-config-pathauto.php "$TYPE" "$BUNDLE" "$LABEL" "$PATTERN"

# 2. Create some dummy content.
if [ -z ${CREATE_DEMO_NODES+x} ]; then 
    printf "    ✔ Skipping content generation.\n"
else 
    if [[ "$CREATE_DEMO_NODES" == true ]]; then
        printf "    ✔ Generating demo article nodes (see https://next-drupal.org/learn/quick-start/create-content).\n"
        NUM_NODES=$(cat $ENV_SETTINGS | jq -r '.project.nodes.demo.num_nodes')
        NODE_DATA=$(cat $ENV_SETTINGS | jq -r '.project.nodes.demo.data')
        printf "        * data: $NODE_DATA\n"
        printf "        * num_nodes: $NUM_NODES\n"
        printf "        ! Get some coffee, this will take a moment...\n"
        drush scr $DRUPAL_SETUP/project/04-create-nodes.php "$NODE_DATA" $NUM_NODES
    else
        printf "    ✔ Skipping content generation.\n"
    fi
fi

# TODO: check the CREATE_DEMO_NODES is set first, and re-reference the catch in the notes section above.
printf "    ✔ Generating demo article nodes (see https://next-drupal.org/learn/quick-start/create-content).\n"
NUM_NODES=$(cat $ENV_SETTINGS | jq -r '.project.nodes.demo.num_nodes')
NODE_DATA=$(cat $ENV_SETTINGS | jq -r '.project.nodes.demo.data')
printf "        * data: $NODE_DATA\n"
printf "        * num_nodes: $NUM_NODES\n"
printf "        ! Get some coffee, this will take a moment...\n"
drush scr $DRUPAL_SETUP/project/04-create-nodes.php "$NODE_DATA" $NUM_NODES
