module Dotenv
  class Environment < Hash
    attr_reader :filename

    def initialize(filename)
      @filename = filename
      load
    end

    def load
      update Parser.call(read)
    end

    def read
      if @filename =~ /crypt$/

        # ==[ Method 1: Ruby methods to mimic openssl's quirky approach ]==
        #
        # require 'openssl'
        #
        # data = File.read(@filename).unpack('m').first
        # pass = ENV['DOTENVCRYPT']
        # salt = data.slice!(0,16)[8,8]
        #
        # k1 = OpenSSL::Digest::MD5.new(     pass + salt).digest
        # k2 = OpenSSL::Digest::MD5.new(k1 + pass + salt).digest
        # iv = OpenSSL::Digest::MD5.new(k2 + pass + salt).digest
        #
        # aes = OpenSSL::Cipher.new('aes-256-cbc').decrypt
        # aes.key = k1 + k2
        # aes.iv = iv
        # aes.update(data) + aes.final

        # ==[ Method 2: OpenSSL commands to encrypt and decrypt ]==
        #
        # To encrypt files on your development machine, first store your key,
        # also called a password, in a UNVERSIONED file called .encryptkey
        #
        # One option is to store a random 256-bit Base64-encoded value:
        #
        #   openssl rand -base64 32 -out .envcryptkey
        #
        # Another option is to just store your key directly:
        #
        #   echo "My_K3wLsEKr!t" > .envcryptkey
        #
        # Only the first line of .envcryptkey is used, so trailing newlines are ok.
        #
        # Then, on your development machine, encrypt with the following command:
        #
        #   openssl aes-256-cbc -a -pass file:.envcryptkey -in .env -out .envcrypt
        #
        # Verify the decrypted output on your development machine with:
        #
        #   openssl aes-256-cbc -d -a -pass file:.envcryptkey -in .envcrypt
        #
        # You can then store your encrypted .envcrypt file in your repo.
        #
        # In production, set the DOTENVCRYPT environment variable to the contents of
        # your .envcryptkey file and files will be decrypted as follows:

        `openssl aes-256-cbc -d -a -pass env:DOTENVCRYPT -in "#{@filename}"`.chomp

      else
        File.read(@filename)
      end
    end

    def apply
      each { |k,v| ENV[k] ||= v }
    end

    def apply!
      each { |k,v| ENV[k] = v }
    end
  end
end
