s/DDD//

t t_ok_1
s/.*/quit!/
q

:t_ok_1
#s/reset T status/T resetted/
s/.*/bla/
t t_ok_2
b 

:t_ok_2
s/.*/reached t2!/
