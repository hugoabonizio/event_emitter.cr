require "./spec_helper"

class MyEmitter
  include EventEmitter::DSL

  on :sync_event, sync: true do |state|
    state[:value] = 2
  end

  on :async_event do |state|
    state[:value] = 3
  end

  def execute_sync(shared_state)
    emit :sync_event, shared_state
  end

  def execute_async(shared_state)
    emit :async_event, shared_state
  end

  on :some_event do |state|
    state[:value] = 4
  end

  on :some_event do |state|
    previous_def(state)
    sleep 10.milliseconds
    state[:value] = 5
  end

  def execute_some_event(shared_state)
    emit :some_event, shared_state
  end
end

describe EventEmitter::DSL do
  it "executes synchronously" do
    shared_state = {:value => 1}
    MyEmitter.new.execute_sync(shared_state)
    shared_state[:value].should eq(2)
  end

  it "executes asynchronously" do
    shared_state = {:value => 1}
    MyEmitter.new.execute_async(shared_state)
    shared_state[:value].should eq(1)
    sleep 10.milliseconds
    shared_state[:value].should eq(3)
  end

  it "stacks hooks" do
    shared_state = {:value => 1}
    MyEmitter.new.execute_some_event(shared_state)
    shared_state[:value].should eq(1)
    sleep 10.milliseconds
    shared_state[:value].should eq(4)
    sleep 20.milliseconds
    shared_state[:value].should eq(5)
  end
end
