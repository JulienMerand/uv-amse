all : ./obj/DCMotor.o ./bin/DCMotor ./obj/SetU.o ./bin/SetU ./obj/ResetState.o ./bin/ResetState ./obj/RegPID.o ./bin/RegPID ./obj/SetTv.o ./bin/SetTv ./obj/Kinematics.o ./bin/Kinematics

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

# ResetState
./obj/ResetState.o : ./src/ResetState.c
		gcc ./src/ResetState.c -c -o ./obj/ResetState.o
./bin/ResetState : ./obj/ResetState.o
		gcc ./obj/ResetState.o -o ./bin/ResetState

# RegPID
./obj/RegPID.o : ./src/RegPID.c
		gcc ./src/RegPID.c -c -o ./obj/RegPID.o
./bin/RegPID : ./obj/RegPID.o
		gcc ./obj/RegPID.o -o ./bin/RegPID

# SetTv
./obj/SetTv.o : ./src/SetTv.c
		gcc ./src/SetTv.c -c -o ./obj/SetTv.o
./bin/SetTv : ./obj/SetTv.o
		gcc ./obj/SetTv.o -o ./bin/SetTv

# Kinematics
./obj/Kinematics.o : ./src/Kinematics.c
		gcc ./src/Kinematics.c -c -o ./obj/Kinematics.o
./bin/Kinematics : ./obj/Kinematics.o
		gcc ./obj/Kinematics.o -o ./bin/Kinematics




