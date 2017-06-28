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

  it "accepts primitive types" do
    emitter = EventEmitter::Base.new
    flag_int = 1
    flag_string = ""
    flag_bool = false

    emitter.on :trigger_int, ->(int : EventEmitter::Base::Any) { flag_int = int }
    emitter.on :trigger_string, ->(string : EventEmitter::Base::Any) { flag_string = string }
    emitter.on :trigger_bool, ->(bool : EventEmitter::Base::Any) { flag_bool = bool }

    emitter.emit :trigger_int, 123
    emitter.emit :trigger_string, "123"
    emitter.emit :trigger_bool, true

    sleep 100.milliseconds
    flag_int.should eq(123)
    flag_string.should eq("123")
    flag_bool.should eq(true)
  end

  it "executes once" do
    emitter = EventEmitter::Base.new
    flag = 1
    emitter.once :trigger do
      flag = 2
    end

    emitter.emit :trigger
    emitter.emit :trigger
    sleep 100.milliseconds
    flag.should eq(2)
  end
end
