class_name StateComponent extends Node

enum StateMachine {Normal, Full, Underwater, UnderwaterFull, Stunned, Burned, Frozen, BeingInhaled, TempInvincible }
@export var CurrentState: StateMachine = StateMachine.Normal
