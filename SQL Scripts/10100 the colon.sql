EXEC sp_execute_external_script
@language = N'Python',
@script = N'
a = [1,2,3,4,5]; # a square bracket defines a list
b = [2,3,4]
print(len(a))
print(a[1:5]) # left parameter means start of slice, if omitted means 0
print(a[2:]) # right parameter means means end of slice, if omitted means end of sequence

for i in a:
	j = i * 2
	print("this is {0} and this is {1} " .format(j, j*2))
	for k in b:
		l = k * j
		print(l)
'