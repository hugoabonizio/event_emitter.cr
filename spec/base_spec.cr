require "./spec_helper"

describe EventEmitter::Base do
  it "executes one listener" do
    emitter = EventEmitter::Base.new
    flag = 1
    emitter.on :event do
      flag = 2
    end

    sleep 100.milliseconds
    emitter.emit :event
    sleep 100.milliseconds
    flag.should eq(2)
  end

  it "executes more than one listeners" do
    emitter = EventEmitter::Base.new
    flag1 = flag2 = 1

    emitter.on :event do
      flag1 = 123
    end

    emitter.on :event do
      flag2 = 321
    end

    flag1.should eq(1)
    flag2.should eq(1)
    sleep 100.milliseconds
    emitter.emit :event
    sleep 100.milliseconds
    flag1.should eq(123)
    flag2.should eq(321)
  end
end
