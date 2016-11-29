
data "template_file" "student_init" {
  count = "${length(var.students)}"
  template = "${file("cloudinit.sh.tpl")}"
}

resource "aws_instance" "student" {
    count = "${length(var.students)}"
    ami = "${data.aws_ami.ubuntu.id}"
    #key_name = "docker-training"
    instance_type = "m3.medium"
    tags {
        Name = "Docker introduction - ${element(var.students,count.index)}"
        Group = "docker-training"
        Owner = "${var.instructor}"
        Student = "${element(var.students,count.index)}"
    }
    user_data = "${element(data.template_file.student_init.*.rendered, count.index)}"
    root_block_device {
      volume_size = 20
    }
}


resource "aws_route53_record" "docker-record" {
    name = "docker-${element(var.students,count.index)}.aws.xebiatechevent.info"
    count = "${length(var.students)}"
    zone_id = "Z28O5PDK1WPCSR"
    type = "A"
    records = ["${element(aws_instance.student.*.public_ip, count.index)}"]
    ttl = "1"
}