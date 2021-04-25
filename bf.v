module main

import os
import os.cmdline

const (
	memory_len = 30_000
	my_name = 'vbf'
	my_version = '1.0.0'
)

struct Result {
mut:
	memory [30000]int
	output string
}

fn main() {
	if '-h' in os.args || os.args.len < 2 {
		show_help()
		exit(0)
	}

	if '-v' in os.args {
		show_version()
		exit(0)
	}

	if '-l' in os.args {
		show_license()
		exit(0)
	}

	mut input := cmdline.option(os.args, '-i', '')

	result := exec(os.args[1], input)
	println(result.output)
}

fn show_help() {
	println('Brainfuck interpreter in V program language (https://vlang.io)')
	println('https://github.com/paulohrpinheiro/vbf')
	println('')
	println('Usage: $my_name PROGRAM [OPTION]')
	println('\t-h\tthis message help')
	println('\t-v\tshow version')
	println('\t-l\tshow license')
	println('\t-i\tinput data for "," command')
}

fn show_version() {
	println('$my_name version: $my_version')
	exit(0)
}

fn show_license() {
	println('MIT License

Copyright (c) 2021 Paulo Henrique Rodrigues Pinheiro

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.')
	exit(0)
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
