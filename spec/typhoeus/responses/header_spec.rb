require 'spec_helper'

describe Typhoeus::Responses::Header do
  let(:raw_header) { nil }
  let(:header) { Typhoeus::Responses::Header.new(raw_header) }

  describe "#parse" do
    context "when no header" do
      it "returns nil" do
        header.should be_empty
      end
    end

    context "when header" do
      let(:raw_header) do
        'HTTP/1.1 200 OK
        Set-Cookie: NID=61=LblqYgUOu; expires=Sat, 29-Dec-2012 10:09:23 GMT; path=/; domain=.google.de; HttpOnly
        Date: Fri, 29 Jun 2012 10:09:23 GMT
        Expires: -1
        Cache-Control: private, max-age=0
        Content-Type: text/html; charset=ISO-8859-1
        Set-Cookie: PREF=ID=77e93yv0hPtejLou; expires=Sun, 29-Jun-2014 10:09:23 GMT; path=/; domain=.google.de
        Set-Cookie: NID=61=LblqYgh5Ou; expires=Sat, 29-Dec-2012 10:09:23 GMT; path=/; domain=.google.de; HttpOnly
        P3P: CP="This is not a P3P policy! See http://www.google.com/support/accounts/bin/answer.py?hl=en&answer=151657 for more info."
        Server: gws
        X-XSS-Protection: 1; mode=block
        X-Frame-Options: SAMEORIGIN
        Transfer-Encoding: chunked'
      end

      it "sets raw_header" do
        header.raw_header.should eq(raw_header)
      end

      it "sets Set-Cookie" do
        header['Set-Cookie'].should have(3).items
      end

      [
        'NID=61=LblqYgUOu; expires=Sat, 29-Dec-2012 10:09:23 GMT; path=/; domain=.google.de; HttpOnly',
        'PREF=ID=77e93yv0hPtejLou; expires=Sun, 29-Jun-2014 10:09:23 GMT; path=/; domain=.google.de',
        'NID=61=LblqYgh5Ou; expires=Sat, 29-Dec-2012 10:09:23 GMT; path=/; domain=.google.de; HttpOnly'
      ].each_with_index do |cookie, i|
        it "sets Cookie##{i}" do
          header['Set-Cookie'].should include(cookie)
        end
      end

      {
        'Date' => 'Fri, 29 Jun 2012 10:09:23 GMT', 'Expires' => '-1',
        'Cache-Control' => 'private, max-age=0',
        'Content-Type' => 'text/html; charset=ISO-8859-1',
        'P3P' => 'CP="This is not a P3P policy! See http://www.google.com/support/accounts/bin/answer.py?hl=en&answer=151657 for more info."',
        'Server' => 'gws', 'X-XSS-Protection' => '1; mode=block',
        'X-Frame-Options' => 'SAMEORIGIN', 'Transfer-Encoding' => 'chunked'
      }.each do |name, value|
        it "sets #{name}" do
          header[name].should eq(value)
        end
      end
    end
  end
end
