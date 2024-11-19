#!/bin/bash

cd ~/UTN-FRA_SO_Examenes/202406/ansible/roles/2do_parcial

cat <<EOF > tasks/main.yml
- name: Crear directorios necesarios
  file:
    path: "/tmp/2do_parcial/{{ item }}"
    state: directory
    mode: '0755'
  loop:
    - alumno
    - equipo

- name: Crear archivo de datos del alumno
  template:
    src: templates/datos_alumno.txt.j2
    dest: /tmp/2do_parcial/alumno/datos_alumno.txt
  vars:
    nombre: "Brandon Ezequiel"
    apellido: "Romero"
    division: "115"

- name: Crear archivo de datos del equipo
  template:
    src: templates/datos_equipo.txt.j2
    dest: /tmp/2do_parcial/equipo/datos_equipo.txt
  vars:
    ip: "192.168.56.3"
    distro: "Ubuntu-jammy"
    cores: "6"

- name: Configurar sudoers para el grupo 2PSupervisores
  copy:
    content: '%2PSupervisores ALL=(ALL) NOPASSWD: ALL'
    dest: /etc/sudoers.d/2psupervisores
    validate: 'visudo -cf %s'
EOF

sudo mkdir -p templates

cat <<EOF > templates/datos_alumno.txt.j2
plaintext
Nombre: {{ nombre }}
Apellido: {{ apellido }}
Division: {{ division }}
EOF

cat <<EOF > templates/datos_equipo.txt.j2
plaintext
IP: {{ ip }}
Distribución: {{ distro }}
Cantidad de Cores: {{ cores }}
EOF

cd ~/UTN-FRA_SO_Examenes/202406/ansible
ansible-playbook -i inventory playbook.yml
