# -*- coding: utf-8 -*-

require_relative 'helpers'

NAME = "ГОСЭКЗАМЕН"

############################################

# Dir.chdir('GExam')

main = read "GE_main.tex"
tmpl = read "GE_tmpl.tex"

main_plain = read "GE_plain.tex"
tmpl_plain = read "GE_tmpl_plain.tex"

exams = get_specs reval('gos_exam.rb'), NAME


run ary: exams, main: main, tmpl: tmpl
run ary: exams, main: main_plain, tmpl: tmpl_plain, list: '_список2'

run_latex exams, repeat: true
run_latex exams, list: '_список2'



