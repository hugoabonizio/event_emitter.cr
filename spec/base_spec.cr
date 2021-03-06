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

    emitter.on :trigger_int { |int| flag_int = int }
    emitter.on :trigger_string { |string| flag_string = string }
    emitter.on :trigger_bool { |bool| flag_bool = bool }

    emitter.emit :trigger_int, 123
    emitter.emit :trigger_string, "123"
    emitter.emit :trigger_bool, true

    sleep 100.milliseconds
    flag_int.should eq(123)
    flag_string.should eq("123")
    flag_bool.should eq(true)
  end

  it "works with recursive types" do
    emitter = EventEmitter::Base.new
    flag_arr = [] of String
    flag_hash = {} of String => String

    emitter.on :trigger_arr { |arr| flag_arr = arr }
    emitter.on :trigger_hash { |hash| flag_hash = hash }

    emitter.emit :trigger_arr, [1, 2, 3, 4, 5]
    emitter.emit :trigger_hash, {"a" => "b"}

    sleep 100.milliseconds
    flag_arr.should eq([1, 2, 3, 4, 5])
    flag_hash.should eq({"a" => "b"})
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

  it "listens to all events" do
    emitter = EventEmitter::Base.new
    flag = 0

    emitter.all do |v|
      flag = v
    end

    emitter.emit(:test1, 7)
    flag.should eq(7)

    emitter.emit(:test2, 3)
    flag.should eq(3)

    emitter.emit(:test3, 9)
    flag.should eq(9)
  end

  it "accepts regex events" do
    emitter = EventEmitter::Base.new
    a = 0
    b = 0

    emitter.on(/^foo.*/) do
      a += 1
    end

    emitter.on(/^bar.*/) do
      b += 1
    end

    emitter.emit(:foo)
    emitter.emit(:foob)
    emitter.emit(:joy)
    emitter.emit("foo.bar")
    emitter.emit("hello")

    emitter.emit(:bar)
    emitter.emit(:bars)
    emitter.emit(:barns)
    emitter.emit("bar.foo")
    emitter.emit("bagel")

    a.should eq(3)
    b.should eq(4)
  end

  it "allows unsubscribing from events" do
    emitter = EventEmitter::Base.new
    a = 0

    emitter.on(:foo) { a += 1 }

    emitter.emit(:foo)

    emitter.remove_listener(:foo)

    emitter.emit(:foo)

    a.should eq(1)
  end
end
