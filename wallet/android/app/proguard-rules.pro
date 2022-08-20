   -keep class io.grpc.** {*;}
   -keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}