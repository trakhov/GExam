require_relative 'helpers'

exams = reval 'gos_exam.rb'
tmpl = read 'GExam_lists.tex'


table = '\smallGE %{bak} {%{spec}} {%{title}}%{type}
\begin{longtable}{|*{6}{l|}}	
	\hline	
	{\bfseries №} & 
	{\bfseries Студент} & 
	\makebox[.25\textwidth]{\bfseries Вопрос №\,1} & 
	\makebox[.25\textwidth]{\bfseries Вопрос №\,2} & 
	\makebox[.25\textwidth]{\bfseries Вопрос №\,3} & 
	\makebox[.074\textwidth]{\bfseries Оценка}  \\\\ \hline
	\endhead

%{contents}

\end{longtable}
\newpage
'

s = "\t%s & \\parbox[t]{3cm}{%s\\\\%s\\\\%s} & & & & \\\\[1cm] \\hline\n"

data = ''

exams.each do |exam|
	bak = if exam[:spec][-1] == '2' then '' else '*' end
	type = if exam[:type] then "[#{exam[:type]}]" else '' end

	filename = exam[:spec]
	if exam[:type]
		filename += " (#{exam[:type]})"
	end
	
	contents = ''
	names = reval "groups/#{exam[:group]}.rb"
	names.each_with_index do |name, i|
		fio = name.split(' ')
		contents += s % [i+1, fio[0], fio[1], fio[2]]
	end

	data += table % {bak: bak, spec: exam[:spec], title: exam[:title], type: type, contents: contents}

end


open('output/Замечания комиссии.tex', 'w') { |file| file.write tmpl % data }

`subl "output/Замечания комиссии".tex`

