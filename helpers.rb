# -*- coding: utf-8 -*-


def get_specs(ary, name)
	out = []

	ary.each do |el|
		el[:bak] = if el[:spec][-1] == '2' then '' else '*' end

		el[:name] = name
		if el[:type]
			el[:name] += " (#{el[:type]})"
		end
		out << el
	end

	out
end



def fulfill(n, *ary)
	questions = []
	mx = [n, ary.max_by { |x| x.size }.size].max

	ary.each do |x|
		if x.size < mx
			shuffled = x.shuffle
			(mx - x.size).times { x << shuffled.pop }
		end
	end

	mx.times { |i| questions << {q1: ary[0][i], q2: ary[1][i], q3: ary[2][i]} }

	questions
end


def get_questions_grouped(ary)
	q1 = ary.select.with_index { |el, i| i % 3 == 0 }
	q2 = ary.select.with_index { |el, i| i % 3 == 1 }
	q3 = ary.select.with_index { |el, i| i % 3 == 2 }

	fulfill 30, q1, q2, q3
end


def get_questions_straight(ary)
	q1 = ary[0..(ary.size / 3 - 1)]
	q2 = ary[(ary.size / 3)..(2 * ary.size / 3 - 1)]
	q3 = ary[(2 * ary.size / 3)..ary.size]

	fulfill 30, q1, q2, q3
end


def get_questions_sorted(ary)
	(ary.size / 3).times.map { |i| {q1: ary[3*i], q2: ary[3*i+1], q3: ary[3*i+2]} }
end


def get_fill(i)
	if i % 3 == 2
		""
	else
		"\\vfill"
	end
end


def read(file)
	open(file, encoding: 'utf-8') { |file| file.read }
end


def readlines(file)
	open(file, encoding: 'utf-8') { |file| file.readlines }
end


def reval(file)
	open(file, encoding: 'utf-8') { |file| eval file.read }
end



def run(enc={encoding: 'utf-8'}, ary: [], main: '%s', tmpl: '%s', list: '')

	ary.each do |exam|

		data = ''
		ary = open("./GE_txt/#{exam[:spec]}/#{exam[:name]}", enc) { |f| f.readlines }
		
		questions = eval "get_questions_#{exam[:sort]} ary"

		type = if exam[:type] then "[#{exam[:type]}]" else '' end

		questions.each.with_index do |q, i|
			data += tmpl % {
				bak: exam[:bak],
				spec_number: exam[:spec],
				spec_title: exam[:title],
				spec_type: type,
				bilet: i+1,
				q1: q[:q1].strip,
				q2: q[:q2].strip,
				q3: q[:q3].strip,
				fill: get_fill(i)
			}
		end

		open("./GE_tex/#{exam[:spec]} #{exam[:name]}#{list}.tex", 'w', enc) do |f| 
			f.write main % {
				data: data, 
				spec: exam[:spec], 
				title: exam[:title], 
				type: type, 
				bak: exam[:bak]
			}
		end
	end
end


def run_latex(exams, repeat: false, list: '', remove: true)
	exams.each do |e|
		cmd = "pdflatex -output-directory output/Госэкзамены " <<
					"'./GE_tex/#{e[:spec]} #{e[:name]}#{list}.tex'"

		system cmd
		system cmd if repeat

		system "cd output/Госэкзамены; rm *aux *log *out" if remove
	end
end



def splt(txt)
	txt.gsub!(/\([^()]*\)/, '')
	if /\s/.match(txt) == nil
		txt + '\\\\'
	elsif txt.length < 15
		txt + '\\\\'
	elsif txt.split(' ')[0].length > 15
		'\\\\ ' + '\\multicolumn{2}{r}{ ' + txt + ' }'		
	else		
		txt.sub(' ', '\\\\\\ \\multicolumn{2}{r}{ ') + ' }'
	end
end

# p splt 'Математика (3, практика)'

