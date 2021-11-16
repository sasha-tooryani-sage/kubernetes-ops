#!/bin/bash
regex='^nvme[1-5]n1$'
while read -a words; do
  if [[ "${words[0]}" =~ $regex ]]
  then
    mp=""
    case "${words[3]}" in
    200G)
      mp="u02"
      ;;
    20G)
      mp="var"
      ;;
    16G)
      mp="swap"
      ;;
    esac
    
    if [[ $mp == "var" ]]
    then 
      mkfs -t xfs "/dev/${words[0]}"
      mkdir "/mnt/$mp"
      mount "/dev/${words[0]}" "/mnt/$mp"
      init 1
      cd "/$mp"
      cp -ax * "/mnt/$mp"
      cd /
      mv "$mp" "$mp.old"
      mkdir "$mp"
      umount "/dev/${words[0]}"
      mount "/dev/${words[0]}" "/$mp"
      echo  "/dev/${words[0]}" "/$mp" xfs defaults,nofail 0 1 >> /etc/fstab
      init 5
    elif [[ $mp == "swap" ]]
    then
      mkswap "/dev/${words[0]}"
      echo /dev/${words[0]} swap swap defaults  0 1 >> /etc/fstab
      swapon -a
    else
      mkfs -t xfs "/dev/${words[0]}"
      mkdir "/$mp"
      mount "/dev/${words[0]}" "/$mp"
      echo  "/dev/${words[0]}" "/$mp" xfs defaults,nofail 0 1 >> /etc/fstab
    fi
  fi
done < <(lsblk)
echo "ClientAliveInterval 120" >> /etc/ssh/sshd_config
echo "ClientAliveCountMax 720" >> /etc/ssh/sshd_config
reboot -h now