#!/bin/bash

set -euo pipefail

set -x

cat > /tmp/cilium.te <<EOF
module cilium 1.0;

require {
        # this is the super privileged container type
        type spc_t;
        class bpf { map_create map_read map_write prog_load prog_run };
}

allow spc_t self:bpf { map_create map_read map_write prog_load prog_run };
EOF

checkmodule -m -m -o /tmp/cilium.mod /tmp/cilium.te
semodule_package -m /tmp/cilium.mod -o /etc/selinux/targeted/modules/active/modules/cilium.pp

# execute module application in the host
nsenter --mount=/proc/1/ns/mnt -- semodule -i /etc/selinux/targeted/modules/active/modules/cilium.pp
