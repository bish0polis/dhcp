require 'spec_helper'

describe 'dhcp::_config' do
  context 'when all attributes are default, on rhel 6.x' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'centos', version: '6.6').converge(described_recipe)
    end

    let(:params) do
      {
        'default-lease-time' => '6400',
        'ddns-domainname' => '"local"',
        'ddns-update-style' => 'interim',
        'max-lease-time' => '86400',
        'update-static-leases' => 'true',
        'one-lease-per-client' => 'true',
        'authoritative' => '',
        'ping-check' => 'true',
        'next-server' => '10.0.0.2',
        'filename' => '"pxelinux.0"'
      }
    end

    let(:opts) do
      {
        'domain-name' => '"local"',
        'domain-name-servers' => '8.8.8.8',
        'host-name' => ' = binary-to-ascii (16, 8, "-", substring (hardware, 1, 6))'
      }
    end

    it 'generates a config file' do
      expect(chef_run).to create_template('/etc/dhcp/dhcpd.conf')
        .with(variables: { allows: ['booting', 'bootp', 'unknown-clients'],
                           parameters: params, options: opts, masters: nil,
                           keys: nil, my_ip: '10.0.0.2', role: nil,
                           peer_ip: nil, failover: false })
      expect(chef_run).to render_file('/etc/dhcp/dhcpd.conf').with_content(File.read(File.join(File.dirname(__FILE__), 'fixtures', 'dhcpd.conf.default')))
    end
  end

  context 'when attributes are overridden, on rhel 6.x' do
    # Only testing overriding node['dhcp']['extra_files']
    # Need to add testing for all other attributes used by _config recipe
    cached(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'centos', version: '6.6') do |node|
        node.set['dhcp']['extra_files'] = ['/etc/dhcp/my_conf.conf', '/tmp/bad.conf']
      end.converge(described_recipe)
    end

    let(:params) do
      {
        'default-lease-time' => '6400',
        'ddns-domainname' => '"local"',
        'ddns-update-style' => 'interim',
        'max-lease-time' => '86400',
        'update-static-leases' => 'true',
        'one-lease-per-client' => 'true',
        'authoritative' => '',
        'ping-check' => 'true',
        'next-server' => '10.0.0.2',
        'filename' => '"pxelinux.0"'
      }
    end

    let(:opts) do
      {
        'domain-name' => '"local"',
        'domain-name-servers' => '8.8.8.8',
        'host-name' => ' = binary-to-ascii (16, 8, "-", substring (hardware, 1, 6))'
      }
    end

    it 'generates config file with noextra config files' do
      expect(chef_run).to create_template('/etc/dhcp/dhcpd.conf')
        .with(variables: { allows: ['booting', 'bootp', 'unknown-clients'],
                           parameters: params, options: opts, masters: nil,
                           keys: nil, my_ip: '10.0.0.2', role: nil,
                           peer_ip: nil, failover: false })
      expect(chef_run).to render_file('/etc/dhcp/dhcpd.conf').with_content(File.read(File.join(File.dirname(__FILE__), 'fixtures', 'dhcpd.conf.overrides')))
    end
  end
end
