function vpn
	switch $argv[1]
		case create
			echo "Creating VM instance..."
			set instance_id (
				vultr-cli instance create \
					--auto-backup false \
					--ipv6 false \
					--os 2136 \
					--plan vc2-1c-1gb \
					--region sgp \
					--tags vpn \
					--ssh-keys d818f0ac-6fa3-4de0-b96f-9a5088f4449c \
					| grep -E "^ID" | awk '{print $2}'
			)
			echo "Instance id = $instance_id"

			echo "Getting instance IP..."
			while not test -n "$instance_ip"; or string match "0.*" "$instance_ip"
				set instance_ip  (vultr-cli instance get $instance_id | grep -E "^MAIN IP" | awk '{print $3}')
				sleep 3
			end
			echo "Instance ip = $instance_ip"

			echo "Waiting for instance to be ready..."
			while not nc -w 10 -zv $instance_ip 22
				sleep 3
			end

			ssh -t -o "StrictHostKeyChecking no" -o "UserKnownHostsFile /dev/null" root@$instance_ip "
				curl -O https://raw.githubusercontent.com/angristan/wireguard-install/39caf2fcf6dec3b55735c70407fab0adf493e8d1/wireguard-install.sh
				chmod +x wireguard-install.sh
				./wireguard-install.sh
			"

			scp -o "StrictHostKeyChecking no" -o "UserKnownHostsFile /dev/null" "root@$instance_ip:*.conf" /mnt/d/
		case delete
			vultr-cli instance delete (
				vultr-cli instance list | grep "\[vpn\]" | awk '{print $1}'
			)
	end
end
