% plot beating

step=0.001;

f1 = 10;
f2 = 11;
real_max = 7;

wf1 = sin(f1*(0:step:real_max));
wf2 = sin(f2*(0:step:real_max));

plot(wf1+wf2);

