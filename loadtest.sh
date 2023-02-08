#!/bin/bash

# prepare an empty directory for the test
rm -rf loadtestData
mkdir loadtestData

TEST_DIR=loadtestData
# use `npx loadtest` to test the performance of the server
# npm install -g loadtest

# the post data is a JSON array, each element has the following format:
# {
    # "topic": "string",
    # "data": "string"
# }
# a simple script to run the load test that evaluates following:
# ● How long does it take to process a single post (performance)?
# ● Does the size of the data submitted to the server impact the performance?
# ● How does the number of requests impact the performance of the server?
# ● How does the level of concurrency impact the performance of the server?

# 1. How long does it take to process a single post (performance) of with a simple single request?
DIR_T1=$TEST_DIR/test_1
mkdir $DIR_T1

TYPE='application/x-www-form-urlencoded'
DATA_0='[{"topic":"test","data":"a"}]'
echo "single request" > $DIR_T1/result_0.txt
npx loadtest -n 1 -c 1 -m POST -T $TYPE --data $DATA_0 http://localhost:8000/ >> $DIR_T1/result_0.txt
# extract the time from the result
echo "single request" > $DIR_T1/time_0.txt
cat $DIR_T1/result_0.txt | grep "Requests per second" >> $DIR_T1/time_0.txt
cat $DIR_T1/result_0.txt | grep "Mean latency" >> $DIR_T1/time_0.txt

# 2. Does the size of the data submitted to the server impact the performance?
MSG_2="size of data: "
DIR_T2=$TEST_DIR/test_2
mkdir $DIR_T2
# 2.1. 1KB
DATA_1='[{"topic":"test","data":"a"}]'
echo $MSG_2 "1KB" > $DIR_T2/result_1.txt
npx loadtest -n 1 -c 1 -m POST -T $TYPE --data $DATA_1 http://localhost:8000/ >> $DIR_T2/result_1.txt
# extract the time from the result
echo $MSG_2 "1KB" > $DIR_T2/time_1.txt
cat $DIR_T2/result_1.txt | grep "Requests per second" >> $DIR_T2/time_1.txt
cat $DIR_T2/result_1.txt | grep "Mean latency" >> $DIR_T2/time_1.txt

# 2.2. 10KB
DATA_2='[{"topic":"test","data":"a'
for i in {1..10}
do
    DATA_2=$DATA_2'a'
done
DATA_2=$DATA_2'"}]'

echo $MSG_2 "10KB" > $DIR_T2/result_2.txt
npx loadtest -n 1 -c 1 -m POST -T $TYPE --data $DATA_2 http://localhost:8000/ >> $DIR_T2/result_2.txt
# extract the time from the result
echo $MSG_2 "10KB" > $DIR_T2/time_2.txt
cat $DIR_T2/result_2.txt | grep "Requests per second" >> $DIR_T2/time_2.txt
cat $DIR_T2/result_2.txt | grep "Mean latency" >> $DIR_T2/time_2.txt

# 2.3. 100KB
DATA_3='[{"topic":"test","data":"a'
for i in {1..100}
do
    DATA_3=$DATA_3'a'
done
DATA_3=$DATA_3'"}]'
echo $MSG_2 "100KB" > $DIR_T2/result_3.txt
npx loadtest -n 1 -c 1 -m POST -T $TYPE --data $DATA_3 http://localhost:8000/ >> $DIR_T2/result_3.txt
# extract the time from the result
echo $MSG_2 "100KB" > $DIR_T2/time_3.txt
cat $DIR_T2/result_3.txt | grep "Requests per second" >> $DIR_T2/time_3.txt
cat $DIR_T2/result_3.txt | grep "Mean latency" >> $DIR_T2/time_3.txt

# 2.4. 1MB
DATA_4='[{"topic":"test","data":"a'
for i in {1..1000}
do
    DATA_4=$DATA_4'a'
done
DATA_4=$DATA_4'"}]'
echo $MSG_2 "1MB" > $DIR_T2/result_4.txt
npx loadtest -n 1 -c 1 -m POST -T $TYPE --data $DATA_4 http://localhost:8000/ >> $DIR_T2/result_4.txt
# extract the time from the result
echo $MSG_2 "1MB" > $DIR_T2/time_4.txt
cat $DIR_T2/result_4.txt | grep "Requests per second" >> $DIR_T2/time_4.txt
cat $DIR_T2/result_4.txt | grep "Mean latency" >> $DIR_T2/time_4.txt

# 2.5. 10MB
DATA_5='[{"topic":"test","data":"a'
for i in {1..10000}
do
    DATA_5=$DATA_5'a'
done
DATA_5=$DATA_5'"}]'
echo $MSG_2 "10MB" > $DIR_T2/result_5.txt
npx loadtest -n 1 -c 1 -m POST -T $TYPE --data $DATA_5 http://localhost:8000/ >> $DIR_T2/result_5.txt
# extract the time from the result
echo $MSG_2 "10MB" > $DIR_T2/time_5.txt
cat $DIR_T2/result_5.txt | grep "Requests per second" >> $DIR_T2/time_5.txt
cat $DIR_T2/result_5.txt | grep "Mean latency" >> $DIR_T2/time_5.txt

# 3. How does the number of requests impact the performance of the server?
MSG_3="number of requests: "
DIR_T3=$TEST_DIR/test_3
mkdir $DIR_T3
# 3.1. 1
echo $MSG_3 "1" > $DIR_T3/result_1.txt
npx loadtest -n 1 -c 1 -m POST -T $TYPE --data $DATA_0 http://localhost:8000/ >> $DIR_T3/result_1.txt
# extract the time from the result
echo $MSG_3 "1" > $DIR_T3/time_1.txt
cat $DIR_T3/result_1.txt | grep "Requests per second" >> $DIR_T3/time_1.txt
cat $DIR_T3/result_1.txt | grep "Mean latency" >> $DIR_T3/time_1.txt

# 3.2. 10
echo $MSG_3 "10" > $DIR_T3/result_2.txt
npx loadtest -n 10 -c 10 -m POST -T $TYPE --data $DATA_0 http://localhost:8000/ >> $DIR_T3/result_2.txt
# extract the time from the result
echo $MSG_3 "10" > $DIR_T3/time_2.txt
cat $DIR_T3/result_2.txt | grep "Requests per second" >> $DIR_T3/time_2.txt
cat $DIR_T3/result_2.txt | grep "Mean latency" >> $DIR_T3/time_2.txt

# 3.3. 100
echo $MSG_3 "100" > $DIR_T3/result_3.txt
npx loadtest -n 100 -c 100 -m POST -T $TYPE --data $DATA_0 http://localhost:8000/ >> $DIR_T3/result_3.txt
# extract the time from the result
echo $MSG_3 "100" > $DIR_T3/time_3.txt
cat $DIR_T3/result_3.txt | grep "Requests per second" >> $DIR_T3/time_3.txt
cat $DIR_T3/result_3.txt | grep "Mean latency" >> $DIR_T3/time_3.txt

# 3.4. 1000
echo $MSG_3 "1000" > $DIR_T3/result_4.txt
npx loadtest -n 1000 -c 1000 -m POST -T $TYPE --data $DATA_0 http://localhost:8000/ >> $DIR_T3/result_4.txt
# extract the time from the result
echo $MSG_3 "1000" > $DIR_T3/time_4.txt
cat $DIR_T3/result_4.txt | grep "Requests per second" >> $DIR_T3/time_4.txt
cat $DIR_T3/result_4.txt | grep "Mean latency" >> $DIR_T3/time_4.txt

# 3.5. 10000
echo $MSG_3 "10000" > $DIR_T3/result_5.txt
npx loadtest -n 10000 -c 10000 -m POST -T $TYPE --data $DATA_0 http://localhost:8000/ >> $DIR_T3/result_5.txt
# extract the time from the result
echo $MSG_3 "10000" > $DIR_T3/time_5.txt
cat $DIR_T3/result_5.txt | grep "Requests per second" >> $DIR_T3/time_5.txt
cat $DIR_T3/result_5.txt | grep "Mean latency" >> $DIR_T3/time_5.txt

# 4. How does the number of concurrent requests impact the performance of the server?
MSG_4="with 5 requests, number of concurrent requests: "
DIR_T4=$TEST_DIR/test_4
mkdir $DIR_T4
# 4.1. 1
echo $MSG_4 "1" > $DIR_T4/result_1.txt
npx loadtest -n 5 -c 1 -m POST -T $TYPE --data $DATA_0 http://localhost:8000/ >> $DIR_T4/result_1.txt
# extract the time from the result
echo $MSG_4 "1" > $DIR_T4/time_1.txt
cat $DIR_T4/result_1.txt | grep "Requests per second" >> $DIR_T4/time_1.txt
cat $DIR_T4/result_1.txt | grep "Mean latency" >> $DIR_T4/time_1.txt

# 4.2. 10
echo $MSG_4 "10" > $DIR_T4/result_2.txt
npx loadtest -n 5 -c 10 -m POST -T $TYPE --data $DATA_0 http://localhost:8000/ >> $DIR_T4/result_2.txt
# extract the time from the result
echo $MSG_4 "10" > $DIR_T4/time_2.txt
cat $DIR_T4/result_2.txt | grep "Requests per second" >> $DIR_T4/time_2.txt
cat $DIR_T4/result_2.txt | grep "Mean latency" >> $DIR_T4/time_2.txt

# 4.3. 100
echo $MSG_4 "100" > $DIR_T4/result_3.txt
npx loadtest -n 5 -c 100 -m POST -T $TYPE --data $DATA_0 http://localhost:8000/ >> $DIR_T4/result_3.txt
# extract the time from the result
echo $MSG_4 "100" > $DIR_T4/time_3.txt
cat $DIR_T4/result_3.txt | grep "Requests per second" >> $DIR_T4/time_3.txt
cat $DIR_T4/result_3.txt | grep "Mean latency" >> $DIR_T4/time_3.txt

# 4.4. 1000
echo $MSG_4 "1000" > $DIR_T4/result_4.txt
npx loadtest -n 5 -c 1000 -m POST -T $TYPE --data $DATA_0 http://localhost:8000/ >> $DIR_T4/result_4.txt
# extract the time from the result
echo $MSG_4 "1000" > $DIR_T4/time_4.txt
cat $DIR_T4/result_4.txt | grep "Requests per second" >> $DIR_T4/time_4.txt
cat $DIR_T4/result_4.txt | grep "Mean latency" >> $DIR_T4/time_4.txt


