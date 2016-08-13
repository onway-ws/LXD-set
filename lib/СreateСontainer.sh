#-----------------------------------------------
# Создать контейнер
#-----------------------------------------------

СreateСontainer () {
lxc launch $imagename $container

#-----------------------------------------------
# Локализация
#-----------------------------------------------
cat <<EOF >./$tmpfile
#время
ln -fs /usr/share/zoneinfo/Europe/Moscow /etc/localtime
dpkg-reconfigure -f noninteractive tzdata
#локаль
locale-gen ru_RU.utf8
dpkg-reconfigure -f noninteractive locales
update-locale LANG=ru_RU.UTF8
EOF

# запуск внутри контейнера
lxc file push --mode=700 ./$tmpfile $container/tmp/$tmpfile
lxc exec $container /tmp/$tmpfile
lxc exec $container rm /tmp/$tmpfile
}
