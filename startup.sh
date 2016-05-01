#!/bin/sh
set -e

if [[ $apikey ]]; then
    sed -i -e "s|# apikey = \"\"|apikey = \"${apikey}\"|"   /opt/mackerel-agent_linux_386/mackerel-agent.conf
fi

if [[ $include ]]; then
    sed -i -e "s|# Configuration for Custm Metrics Plugins|include = \"${include}\"|"   /opt/mackerel-agent_linux_386/mackerel-agent.conf
fi

if [[ $auto_retirement ]]; then
    trap '/opt/mackerel-agent_linux_386/mackerel-agent retire -force' TERM KILL
fi

if [[ $enable_docker_plugin ]]; then
    echo [plugin.metrics.docker] >>   /opt/mackerel-agent_linux_386/mackerel-agent.conf
    echo command = \"/opt/mackerel-agent_linux_386/mackerel-plugin-docker -name-format name\" >>   /opt/mackerel-agent_linux_386/mackerel-agent.conf
fi

echo /opt/mackerel-agent_linux_386/mackerel-agent -apikey=${apikey} --conf=/opt/mackerel-agent_linux_386/mackerel-agent.conf $opts
/opt/mackerel-agent_linux_386/mackerel-agent -apikey=${apikey} --conf=/opt/mackerel-agent_linux_386/mackerel-agent.conf $opts &
wait ${!}
