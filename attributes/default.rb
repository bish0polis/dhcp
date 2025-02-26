default['dhcp']['failover'] = nil
default['dhcp']['failover_lease_hack'] = false
default['dhcp']['failover_params']['mclt'] = 3600
default['dhcp']['failover_params']['port'] = 647
default['dhcp']['failover_params']['peer_port'] = 647
default['dhcp']['failover_params']['auto_partner_down'] = 0

default['dhcp']['allows'] = %w(booting bootp unknown-clients)

# these are the arrays that dispatch to bags or attributes for actual data
default['dhcp']['hosts'] = []
default['dhcp']['groups'] = []
default['dhcp']['networks'] = []
default['dhcp']['shared_networks'] = []
default['dhcp']['interfaces'] = []

# turn bag support on/off
default['dhcp']['use_bags'] = true

# extra config files
default['dhcp']['extra_files'] = []

# these are the lookup keys for bag names
default['dhcp']['hosts_bag'] = 'dhcp_hosts'
default['dhcp']['groups_bag'] = 'dhcp_groups'
default['dhcp']['networks_bag'] = 'dhcp_networks'

# these are the attribute keys used for records when not using bags
default['dhcp']['host_data'] = {}
default['dhcp']['group_data'] = {}
default['dhcp']['network_data'] = {}
default['dhcp']['shared_network_data'] = {}

default['domain'] = 'local'

default['dhcp']['parameters']['default-lease-time'] = '6400'
default['dhcp']['parameters']['ddns-domainname'] = "\"#{node['domain']}\""
default['dhcp']['parameters']['ddns-update-style'] = 'interim'
default['dhcp']['parameters']['max-lease-time'] = '86400'
default['dhcp']['parameters']['update-static-leases'] = 'true'
default['dhcp']['parameters']['one-lease-per-client'] = 'true'
default['dhcp']['parameters']['authoritative'] = ''
default['dhcp']['parameters']['ping-check'] = 'true'
default['dhcp']['parameters']['next-server'] = node['ipaddress']
default['dhcp']['parameters']['filename'] = '"pxelinux.0"'

default['dhcp']['options']['domain-name'] = "\"#{node['domain']}\""
default['dhcp']['options']['domain-name-servers'] = '8.8.8.8'
default['dhcp']['options']['host-name'] = ' = binary-to-ascii (16, 8, "-", substring (hardware, 1, 6))'

default['dhcp']['dir'] = '/etc/dhcp'
default['dhcp']['init_config'] = '/etc/sysconfig/dhcpd'
default['dhcp']['dhcpd_leases'] = '/var/lib/dhcpd/dhcpd.leases'
default['dhcp']['config_file']  = '/etc/dhcp/dhcpd.conf'

case node['platform_family']
when 'rhel', 'fedora'
  default['dhcp']['package_name'] = 'dhcp'
  default['dhcp']['service_name'] = 'dhcpd'
  default['dhcp']['init_config']  = '/etc/sysconfig/dhcpd'
  default['dhcp']['init_iface'] = 'DHCPDARGS'
  default['dhcp']['dhcpd_leases'] = '/var/lib/dhcpd/dhcpd.leases'

when 'debian'
  default['dhcp']['package_name'] = 'isc-dhcp-server'
  default['dhcp']['service_name'] = 'isc-dhcp-server'

  default['dhcp']['init_config']  = '/etc/default/isc-dhcp-server'
  default['dhcp']['dhcpd_leases'] = '/var/lib/dhcp/dhcpd.leases'
  default['dhcp']['init_iface'] = 'INTERFACES'
end

default['dhcp']['hooks'] = {}
