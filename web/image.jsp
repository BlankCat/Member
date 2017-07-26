<%@page import="java.io.OutputStream"%>
<%@ page contentType="image/jpeg"
		 import="java.awt.*,java.awt.image.*,java.util.*,javax.imageio.*,com.sun.image.codec.jpeg.JPEGCodec,com.sun.image.codec.jpeg.JPEGImageEncoder"
		 pageEncoding="utf-8"%>
	<%!
	Color getRandColor(int fc,int bc)
	{
		Random random = new Random();
		if(fc>255) fc=255;
		if(bc>255) bc=255;
		int r=fc+random.nextInt(bc-fc);
		int g=fc+random.nextInt(bc-fc);
		int b=fc+random.nextInt(bc-fc);
		return new Color(r,g,b);
	}
%>
<%

	response.setHeader("Pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.setDateHeader("Expires", 0);
	//解决验证码不存在http://tieba.baidu.com/p/2326575351
	response.setContentType("image/jpeg");

	int width=60, height=20;
	BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
	Graphics g = image.getGraphics();
	Random random = new Random();
	g.setColor(getRandColor(200,250));
	g.fillRect(0, 0, width, height);
	g.setFont(new Font("Times New Roman",Font.PLAIN,18));
	g.setColor(getRandColor(160,200));
	//绘制多个干扰点
	for (int i=0;i<155;i++)
	{
		int x = random.nextInt(width);
		int y = random.nextInt(height);
		int xl = random.nextInt(12);
		int yl = random.nextInt(12);
		g.drawLine(x,y,x+xl,y+yl);
	}
	String sRand="";
	for (int i=0;i<4;i++){
	String rand=String.valueOf(random.nextInt(10));
	sRand+=rand;
	g.setColor(new Color(20+random.nextInt(110),20+random.nextInt(110),20+random.nextInt(110)));
	g.drawString(rand,13*i+6,16);
	}
	// 将认证码存入SESSION
	session.setAttribute("sRand",sRand);
//	System.out.println("sRand----------"+sRand);
//	response.reset(); //如果不加此句，在weblogic下，验证码不显示。
	g.dispose();
//	System.out.println("getOutputStream()----------"+response.getOutputStream());
//	System.out.println("image----------"+image);
	ImageIO.write(image, "JPEG", response.getOutputStream());
	response.getOutputStream().flush();
	response.getOutputStream().close();
//	JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(response.getOutputStream());
//	encoder.encode(image);
%>
