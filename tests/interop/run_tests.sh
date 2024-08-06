#!/usr/bin/bash

export EXTERNAL_TEST="true"
export WORKSPACE=/tmp

if [ -z "${KUBECONFIG}" ]; then
    echo "No kubeconfig file set for hub cluster"
    exit 1
fi

if [ -z "${KUBECONFIG_EDGE}" ]; then
    echo "No kubeconfig file set for edge cluster"
    exit 1
fi

pytest -lv --disable-warnings test_subscription_status_hub.py --kubeconfig $KUBECONFIG --junit-xml /tmp/test_subscription_status_hub.xml

pytest -lv --disable-warnings test_subscription_status_edge.py --kubeconfig $KUBECONFIG_EDGE --junit-xml /tmp/test_subscription_status_edge.xml

pytest -lv --disable-warnings test_validate_hub_site_components.py --kubeconfig $KUBECONFIG --junit-xml /tmp/test_validate_hub_site_components.xml

KUBECONFIG=$KUBECONFIG_EDGE pytest -lv --disable-warnings test_validate_edge_site_components.py --kubeconfig $KUBECONFIG_EDGE --junit-xml /tmp/test_validate_edge_site_components.xml
