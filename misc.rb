# -*- coding: utf-8

# p Dir.pwd
open(Dir.glob("txt/101101/Менеджмент.txt")[0], encoding: 'utf-8') { |f| print f.read }
