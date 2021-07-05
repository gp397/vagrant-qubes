# Vagrant::Qubes

This is a vagrant provider for qubes.

If you don't know what qubes is, this is probably not somehting that you will want to experiment with yet.

The strucutre, and large chunks of code in here have been inspired by (and in some cases copied from) Jonathan Senkerik's ESXi plugin "vagrant-vmware-esxi" https://github.com/josenk/vagrant-vmware-esxi  without the help of that I wouldn't have been able to put this together.

Right now, this should be considered alpha at best, basic "up" and "Destroy" works for a minimally configured AppVM based on a Vagrantfile along these lines

```
vms = {
  "test1" => ["AppVM","red","fedora-33", 2,  2048, "sys-firewall"],
  "test2" => ["AppVM","red","fedora-33", 2,  2048, "sys-firewall"],
  "test3" => ["AppVM","red","fedora-33", 2,  2048, "sys-firewall"],
}

Vagrant.configure("2") do |config|
  vms.each do | (name, cfg) |
    type, label, template, numvcpus, memory, network = cfg

    config.vm.define name do |machine|
      machine.vm.box = "box"
      machine.vm.hostname = name
      machine.vm.provider :vagrant_qubes do |qubes|
        qubes.guest_type = type
        qubes.guest_label = label
        qubes.guest_template = template
        qubes.guest_netvm = network
        qubes.guest_memsize = memory
        qubes.guest_numvcpus = numvcpus
      end
    end
  end
end
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vagrant-qubes'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install vagrant-qubes

## Usage

TODO: Write usage instructions here

## Development

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gp397/vagrant-qubes. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/vagrant-qubes/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Vagrant::Qubes project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/vagrant-qubes/blob/master/CODE_OF_CONDUCT.md).
