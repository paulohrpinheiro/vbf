module main

import os

const (
	memory_len = 50
)

struct Result {
mut:
	memory [50]int
	output string
}

fn main() {
	if os.args.len < 2 {
		println('Please, give me a brainfuck program as argument!!!')
		return
	}

	result := exec(os.args[1], "")
	println(result.output)
}

fn exec(program string, input string) Result {
	mut pos_input := 0
	mut pos_memory := 0
	mut pos_program := 0
	mut result := Result{}

	for pos_program < program.len {
		mut instruction := program[pos_program]
		match instruction {
			`+` {
				result.memory[pos_memory] += 1
			}
			`-` {
				result.memory[pos_memory] -= 1
			}
			`>` {
				pos_memory += 1
			}
			`<` {
				pos_memory -= 1
			}
			`.` {
				result.output += rune(result.memory[pos_memory]).str()
			}
			`[` {
				if result.memory[pos_memory] == 0 {
					mut depth := 1
					for depth > 0 {
						pos_program += 1
						instruction = program[pos_program]
						if instruction == `[` {
							depth += 1
						} else if instruction == `]` {
							depth -= 1
						}
					}
				}
			}
			`]` {
				mut depth := 1
				for depth > 0 {
					pos_program -= 1
					instruction = program[pos_program]
					if instruction == `[` {
						depth -= 1
					} else if instruction == `]` {
						depth += 1
					}
				}
				pos_program -= 1
			}
			`,` {
				result.memory[pos_memory] = int(input[pos_input])
				pos_input += 1
			}
			else {}
		}

		if pos_memory < 0 {
			pos_memory = memory_len - 1
		}

		if pos_memory >= memory_len {
			pos_memory = 0
		}

		pos_program += 1
	}

	return result
}
