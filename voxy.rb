# /app/services/voxy.rb
require 'uri'
require 'digest'
require 'net/http'

class VoxyService
  attr_accessor :params

  def initialize(params = {})
    self.params = params
  end

  def get_header(data)
    hashed = URI.encode_www_form(data.sort_by {|k, v| k})
    return "Voxy #{VOXY_API_KEY}:#{Digest::SHA256.hexdigest(VOXY_API_SECRET + hashed)}"
  end

  def get_language_support
    uri = URI("#{VOXY_API_URL}/supported_languages")
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      req = Net::HTTP::Get.new uri
      req['Authorization'] = get_header({})
      http.request req
    end

    JSON.parse(res.body)
  end

  def update_user(external_user_id)
    uri = URI("#{VOXY_API_URL}/partners/users/#{external_user_id}")
    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      req = Net::HTTP::Put.new uri
      req['AUTHORIZATION'] = get_header(self.params)
      req.form_data = self.params
      http.request req
    end
    [res.body, res.code]
  end

  def get_users
    uri = URI("#{VOXY_API_URL}/partners/users")
    query = self.params

    uri.query = URI.encode_www_form(query) if query.present?

    res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      req = Net::HTTP::Get.new uri
      req['Authorization'] = get_header({})
      http.request req
    end
    JSON.parse(res.body)
  end

  def get_user(external_user_id)
    uri = URI("#{VOXY_API_URL}/partners/users/#{external_user_id}")
    query = self.params

    uri.query = URI.encode_www_form(query) if query.present?

    res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      req = Net::HTTP::Get.new uri
      req['Authorization'] = get_header({})
      http.request req
    end
    JSON.parse(res.body)
  end

  def get_access_type(external_user_id)
    uri = URI("#{VOXY_API_URL}/partners/users/#{external_user_id}/access_type")
    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      req = Net::HTTP::Put.new uri
      req['AUTHORIZATION'] = get_header(self.params)
      req.form_data = self.params
      http.request req
    end
    [res.body, res.code]
  end

  def get_assessments(external_user_id)
    uri = URI("#{VOXY_API_URL}/partners/users/#{external_user_id}/assessments")
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      req = Net::HTTP::Get.new uri
      req['Authorization'] = get_header({})
      http.request req
    end
    {
      code: res.code,
      body: JSON.parse(res.body)
    }
  end

  def get_auth_token(external_user_id)
    uri = URI("#{VOXY_API_URL}/partners/users/#{external_user_id}/auth_token")
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      req = Net::HTTP::Get.new uri
      req['Authorization'] = get_header({})
      http.request req
    end
    {
      code: res.code,
      body: res.body
    }
  end

  def add_credits(external_user_id)
    data = self.params
    uri = URI("#{VOXY_API_URL}/partners/users/#{external_user_id}/entitlements")
    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      req = Net::HTTP::Post.new uri
      req['AUTHORIZATION'] = get_header(data)
      req.form_data = data
      http.request req
    end
    {
      code: res.code,
      body: JSON.parse(res.body)
    }
  end

  def reset_units(external_user_id)
    data = self.params
    uri = URI("#{VOXY_API_URL}/partners/users/#{external_user_id}/units")
    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      req = Net::HTTP::Post.new uri
      req['AUTHORIZATION'] = get_header(data)
      req.form_data = data
      http.request req
    end
    {
      code: res.code,
      body: JSON.parse(res.body)
    }
  end

  def get_units(external_user_id)
    uri = URI("#{VOXY_API_URL}/partners/users/#{external_user_id}/units")
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      req = Net::HTTP::Get.new uri
      req['Authorization'] = get_header({})
      http.request req
    end
    {
      code: res.code,
      body: JSON.parse(res.body)
    }
  end

  def get_group_sessions_units(external_user_id)
    uri = URI("#{VOXY_API_URL}/partners/users/#{external_user_id}/units")
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      req = Net::HTTP::Get.new uri
      req['Authorization'] = get_header({})
      http.request req
    end
    {
      code: res.code,
      body: JSON.parse(res.body)
    }
  end

  def get_group_sessions_feedback(group_session_id)
    uri = URI("#{VOXY_API_URL}/partners/group_sessions/#{group_session_id}/feedback")
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      req = Net::HTTP::Get.new uri
      req['Authorization'] = get_header({})
      http.request req
    end
    {
      code: res.code,
      body: JSON.parse(res.body)
    }
  end

  def get_tutor(external_user_id)
    uri = URI("#{VOXY_API_URL}/partners/group_sessions/tutor/#{group_session_id}")
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      req = Net::HTTP::Get.new uri
      req['Authorization'] = get_header({})
      http.request req
    end
    {
      code: res.code,
      body: JSON.parse(res.body)
    }
  end

  def get_segments
    uri = URI("#{VOXY_API_URL}/partners/segments")
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      req = Net::HTTP::Get.new uri
      req['Authorization'] = get_header({})
      http.request req
    end
    {
      code: res.code,
      body: JSON.parse(res.body)
    }
  end

  def create_segment
    uri = URI("#{VOXY_API_URL}/partners/segments")
    data = self.params

    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      req = Net::HTTP::Post.new uri
      req['AUTHORIZATION'] = get_header(data)
      req.form_data = data
      http.request req
    end
    {
      code: res.code,
      body: JSON.parse(res.body)
    }
  end

  def assign_user_segment(label, external_user_id)
    uri = URI("#{VOXY_API_URL}/partners/segments/#{label}/users/#{external_user_id}")
    data = self.params

    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      req = Net::HTTP::Post.new uri
      req['AUTHORIZATION'] = get_header(data)
      req.form_data = data
      http.request req
    end
    {
      code: res.code,
      body: JSON.parse(res.body)
    }
  end


  def get_segments_label_units(label)
    uri = URI("#{VOXY_API_URL}/partners/segments/#{label}/users/units")
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      req = Net::HTTP::Get.new uri
      req['Authorization'] = get_header({})
      http.request req
    end
    {
      code: res.code,
      body: JSON.parse(res.body)
    }
  end

  def get_segments_label_group_sessions(label)
    uri = URI("#{VOXY_API_URL}/partners/segments/#{label}/users/group_sessions")
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      req = Net::HTTP::Get.new uri
      req['Authorization'] = get_header({})
      http.request req
    end
    {
      code: res.code,
      body: JSON.parse(res.body)
    }
  end

  def get_feature_group
    uri = URI("#{VOXY_API_URL}/partners/feature_groups")
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      req = Net::HTTP::Get.new uri
      req['Authorization'] = get_header({})
      http.request req
    end
    {
      code: res.code,
      body: JSON.parse(res.body)
    }
  end

  def add_user_to_feature_group(group_id)
    data = self.params
    uri = URI("#{VOXY_API_URL}/partners/feature_groups/#{group_id}/users")
    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      req = Net::HTTP::Post.new uri
      req['AUTHORIZATION'] = get_header(data)
      req.form_data = data
      http.request req
    end
    {
      code: res.code,
      body: JSON.parse(res.body)
    }
  end

  def get_feature_group_group_sessions(group_id)
    uri = URI("#{VOXY_API_URL}/partners/feature_groups/#{group_id}/group_sessions")
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      req = Net::HTTP::Get.new uri
      req['Authorization'] = get_header({})
      http.request req
    end
    {
      code: res.code,
      body: JSON.parse(res.body)
    }
  end

  def get_group_sessions
    uri = URI("#{VOXY_API_URL}/partners/group_sessions")
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      req = Net::HTTP::Get.new uri
      req['Authorization'] = get_header({})
      http.request req
    end
    {
      code: res.code,
      body: JSON.parse(res.body)
    }
  end

  def get_campaigns(pk = nil)
    uri = pk.present? ?  URI("#{VOXY_API_URL}/partners/campaigns/#{pk}") : URI("#{VOXY_API_URL}/partners/campaigns")
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      req = Net::HTTP::Get.new uri
      req['Authorization'] = get_header({})
      http.request req
    end
    {
      code: res.code,
      body: JSON.parse(res.body)
    }
  end

  def get_user_campaigns(pk = nil)
    uri = pk.present? ?  URI("#{VOXY_API_URL}/partners/user_campaigns/#{pk}") : URI("#{VOXY_API_URL}/partners/user_campaigns")
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      req = Net::HTTP::Get.new uri
      req['Authorization'] = get_header({})
      http.request req
    end
    {
      code: res.code,
      body: JSON.parse(res.body)
    }
  end

  def create_user_campaigns
    data = self.params
    uri = URI("#{VOXY_API_URL}/partners/user_campaigns")
    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      req = Net::HTTP::Post.new uri
      req['AUTHORIZATION'] = get_header(data)
      req.form_data = data
      http.request req
    end
    {
      code: res.code,
      body: JSON.parse(res.body)
    }
  end

  def update_user_campaigns(pk)
    data = self.params
    uri = URI("#{VOXY_API_URL}/partners/user_campaigns")
    res = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      req = Net::HTTP::Put.new uri
      req['AUTHORIZATION'] = get_header(data)
      req.form_data = data
      http.request req
    end
    {
      code: res.code,
      body: JSON.parse(res.body)
    }
  end

  def create_user(external_user_id)
    data = self.params
    uri = URI("#{VOXY_API_URL}/partners/users/#{external_user_id}")
    Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      req = Net::HTTP::Post.new uri
      req['AUTHORIZATION'] = get_header(data)
      req.form_data = data
      res = http.request req
    end
  end



end
