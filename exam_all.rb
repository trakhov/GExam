# -*- coding: utf-8 -*-

require_relative 'helpers'

enc = {encoding: 'utf-8'}

courses = open('courses.rb') { |f| eval f.read }


############################################

# Dir.chdir('GExam')
# print Dir.glob('txt/101101/*')[0]
print Dir.pwd

tmpl_data = open("tmpl_data_3", enc) { |file| file.read }
tmpl_tex = open("tmpl_tex", enc) { |file| file.read }

courses.each do |spec_full, courses|
	courses.each do |course|
		spec = spec_full.match(/(\d+)/)[1]
		# print "#{course.join(', ')}\n"

		out = "#{spec}_#{course[0]}.tex"
			.gsub(/,*\s/, '_')
			.gsub(/[()]/, '')

		data = open("./data/#{out}", 'w', enc)	
		lines = open("./txt/#{spec}/#{course[0]}.txt", enc) { |f| f.readlines }


		# первый-последний, второй-предпоследний
		# tasks = (0..lines.length/2-1).map { |i| [lines[i], lines[-i-1]] }


		# список пополам, первый: случайный из первой части, второй: случайный из второй части
		# tasks = []
		# t1, t2 = lines[0...lines.size/2].shuffle, lines[lines.size/2...lines.size].shuffle		
		# if t1.size != t2.size
		# 	mn = [t1, t2].min_by { |ary| ary.size }
		# 	mn << mn.sample
		# end
		# t1.size.times { tasks << [t1.pop, t2.pop] }


		# первый-второй, третий-четвертый
		# tasks = (lines.size/2).times.map { |i| [lines[2*i], lines[2*i+1]] }

		# первый-тридцатый, второй-тридцать первый
		# ????


		# для трех теор. вопросов в билете
		# первый-второй-третий, 4-5-6, 7-8-9
		tasks = (lines.size/3).times.map { |i| [lines[3*i], lines[3*i+1], lines[3*i+2]] }


		tasks.each do |task|
			data.write(tmpl_data % task)
		end
		data.close


		data = open("./data/#{out}", enc) { |f| f.read }
		
		open("./tex/#{spec}/#{out}", 'w', enc).write(tmpl_tex % {
			height: if course[0].match(/практика/) then 188 else 99 end,
			disc: splt(course[0]),
			spec: spec,
			kafedra: course[1],
			protocol: '',
			data: data
			})

		cmd = "pdflatex -output-directory output/#{spec} tex/#{spec}/#{out}; "
		cmd += "cd output/#{spec}; rm *aux *log"

		system cmd
	end
end
