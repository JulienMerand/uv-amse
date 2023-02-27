all : ./obj/DCMotor.o ./bin/DCMotor ./obj/SetU.o ./bin/SetU

# DCMotor
./obj/DCMotor.o : ./src/DCMotor.c
		gcc ./src/DCMotor.c -c -o ./obj/DCMotor.o
./bin/DCMotor : ./obj/DCMotor.o
		gcc ./obj/DCMotor.o -lm -o ./bin/DCMotor

# SetU
./obj/SetU.o : ./src/SetU.c
		gcc ./src/SetU.c -c -o ./obj/SetU.o
./bin/SetU : ./obj/SetU.o
		gcc ./obj/SetU.o -o ./bin/SetU

