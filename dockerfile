# Используем образ с QEMU и ARM-поддержкой
FROM ubuntu:22.04

# Установка зависимостей и QEMU
RUN apt-get update && \
    apt-get install -y qemu-system-arm wget unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Создаем рабочую директорию и копируем образ
WORKDIR /romulus
COPY romulus/obmc-phosphor-image-romulus-20250214213550.static.mtd /romulus/

# Запускаем QEMU с указанными параметрами
CMD ["qemu-system-arm", \
     "-m", "256", \
     "-M", "romulus-bmc", \
     "-nographic", \
     "-drive", "file=/romulus/obmc-phosphor-image-romulus-20250214213550.static.mtd,format=raw,if=mtd", \
     "-net", "nic", \
     "-net", "user,hostfwd=:0.0.0.0:2222-:22,hostfwd=:0.0.0.0:2443-:443,hostfwd=udp:0.0.0.0:2623-:623"]